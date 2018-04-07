const router = require('express').Router
const co = require('co')
const request = require('axios')
const uuid = require('uuid')
const jwt = require('jsonwebtoken')
const redis = require('../redis')
const {getAcccessTokenKey} = require('./util/redis-keys')

const sessionRouter = router()

const graphApi = 'https://graph.facebook.com/v2.11/'

sessionRouter.post('/login', (req, res) => co(function * () {
  const accessTokenResponse = yield request.get(graphApi + 'oauth/access_token', {
    params: {
      client_id: global.config.fbAppId, // eslint-disable-line camelcase
      redirect_uri: global.config.fbRedirectUri, // eslint-disable-line camelcase
      client_secret: global.config.fbClientSecret, // eslint-disable-line camelcase
      code: req.body.code
    }
  })

  const accessToken = accessTokenResponse.data.access_token
  const expiry = accessTokenResponse.data.expires_in
  const sessionId = uuid.v4()

  const userIdResponse = yield request.get(graphApi + 'me?fields=id,first_name&access_token=' + accessToken)

  const userId = userIdResponse.data.id

  redis.set(
    getAcccessTokenKey(sessionId),
    accessToken,
    'EX',
    expiry
  )

  const sessionToken = jwt.sign({userId, sessionId}, global.config.appSecret, {expiresIn: '2d'})

  res.cookie('token', sessionToken, {maxAge: 900000, httpOnly: true})
}).catch(err => {
  global.logger.error(err, 'session error')
  return res.status(400).json({
    success: false
  })
}))

sessionRouter.get('/load', (req, res) => co(function * () {
  const token = res.locals.token

  const {userId, sessionId} = yield jwt.verify(token, global.config.appSecret)

  const accessTokenResponse = yield redis.get(getAcccessTokenKey(sessionId))

  const nameResponse = yield request.get(graphApi + '/me?fields=first_name&access_token=' + accessTokenResponse)

  return res.json({
    username: nameResponse.data.first_name,
    userId
  })
}).catch(err => {
  global.logger.error(err)
  return res.status(400).json({
    success: false
  })
}))

module.exports = sessionRouter
