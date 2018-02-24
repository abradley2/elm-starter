const uuid = require('uuid')
const jwt = require('jsonwebtoken')
const cuid = require('cuid')
const router = require('express').Router
const co = require('co')
const redis = require('../redis')
const {
  getQuestsListKey,
  getSuggestedSideQuestsKey
} = require('./util/redis-keys')

const sideQuestsRouter = router()

sideQuestsRouter.get('/:userId', (req, res) => co(function * () {
  const userId = req.params.userId
  const questId = req.query.questId

  const userQuests = yield redis.lrange(getQuestsListKey(userId), 0, -1)

  const quest = userQuests
    .map(JSON.parse)
    .reduce((found, userQuest) =>
      userQuest.id === questId ?
        userQuest :
        found
    , null)

  res.json({
    quest: Object.assign({}, quest, {upvotes: quest.upvotes.length}),
    sideQuests: quest.sideQuests
  })
}).catch(err => {
  global.logger.error(err, 'error getting sidequests')

  return res.sendStatus(500)
}))

sideQuestsRouter.post('/:userId/:questId', (req, res) => co(function * () {
  const userId = req.params.userId
  const questId = req.params.questId

  const user = yield jwt.verify(res.locals.token, global.config.appSecret)

  const suggestedQuest = Object.assign({}, req.body, {
    id: cuid(),
    guid: uuid.v4(),
    suggestedBy: user.userId
  })

  yield redis.lpush(getSuggestedSideQuestsKey(userId, questId), JSON.stringify(suggestedQuest))

  return res.sendStatus(200)
}).catch(err => {
  global.logger.error(err, 'error suggesting sidequest')

  return res.sendStatus(500)
}))

module.exports = sideQuestsRouter
