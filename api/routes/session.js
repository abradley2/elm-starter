const router = require('express').Router
const co = require('co')
const request = require('axios')
const uuid = require('uuid')
const jwt = require('jsonwebtoken')
const redis = require('../redis')
const {getAcccessTokenKey} = require('./util/redis-keys')

const sessionRouter = router()

const graphApi = 'https://graph.facebook.com/v2.11/'

sessionRouter.get('/load', (req, res) => co(function * () {
  let username = null
  let userId = null
  // if we already have a token parse it and send back the user information
  if (res.locals.token) {
    const token = res.locals.token

    const sessionInfo = yield jwt.verify(token, global.config.appSecret)

    const accessTokenResponse = yield redis.get(getAcccessTokenKey(sessionInfo.sessionId))

    userId = sessionInfo.userId
    const userResponse = yield request.get(graphApi + '/me?fields=first_name&access_token=' + accessTokenResponse)
    username = userResponse.data.first_name
  }
  // if its sending in a code go through oauth
  if (!res.locals.token && req.query.code) {
    const accessTokenResponse = yield request.get(graphApi + 'oauth/access_token', {
      params: {
        client_id: global.config.fbAppId, // eslint-disable-line camelcase
        redirect_uri: global.config.fbRedirectUri, // eslint-disable-line camelcase
        client_secret: global.config.fbClientSecret, // eslint-disable-line camelcase
        code: req.query.code
      }
    })

    const accessToken = accessTokenResponse.data.access_token
    const expiry = accessTokenResponse.data.expires_in
    const sessionId = uuid.v4()

    const userResponse = yield request.get(graphApi + 'me?fields=id,first_name&access_token=' + accessToken)

    userId = userResponse.data.id
    username = userResponse.data.first_name

    redis.set(
      getAcccessTokenKey(sessionId),
      accessToken,
      'EX',
      expiry
    )

    const sessionToken = jwt.sign({userId, sessionId}, global.config.appSecret, {expiresIn: '2d'})

    res.header('Set-Cookie', `token=${sessionToken}; Max-Age=${accessTokenResponse.data.expires_in}; Path=/; HttpOnly`)
  }

  return res.json({
    username,
    userId
  })
}).catch(err => {
  global.console.error(err.response.data)
  global.logger.error(err)
  return res.status(400).json({
    success: false
  })
}))

module.exports = sessionRouter
