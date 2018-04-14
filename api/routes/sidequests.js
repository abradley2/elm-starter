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

  // if this is from the creator of the quest add it to the sidequests
  if (user.userId === req.params.userId) {
    const userQuests = yield redis.lrange(getQuestsListKey(userId), 0, -1)

    const [quest, questIdx] = userQuests
      .map(JSON.parse)
      .reduce((found, userQuest, idx) =>
        userQuest.id === questId ?
          [userQuest, idx] :
          found
      , null)

    const updatedQuest = Object.assign({}, quest, {
      sideQuests: quest.sideQuests.concat(suggestedQuest)
    })

    yield redis.lset(getQuestsListKey(userId), questIdx, JSON.stringify(updatedQuest))

    return res.json({sideQuests: updatedQuest.sideQuests})
  }
  // otherwise add it to the quests "suggested" side quests
  yield redis.lpush(getSuggestedSideQuestsKey(userId, questId), JSON.stringify(suggestedQuest))

  const sideQuests = yield redis.lrange(getSuggestedSideQuestsKey(userId, questId), 0, -1)

  return res.json({sideQuests: sideQuests.map(JSON.parse)})
}).catch(err => {
  global.logger.error(err, 'error suggesting sidequest')

  return res.sendStatus(500)
}))

module.exports = sideQuestsRouter
