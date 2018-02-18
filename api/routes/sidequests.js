const router = require('express').Router
const co = require('co')
const redis = require('../redis')
const {
  getQuestsListKey
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
  global.console.error(err)
  global.logger.error(err, 'error getting sidequests')

  return res.sendStatus(500)
}))

module.exports = sideQuestsRouter
