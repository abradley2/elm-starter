const uuid = require('uuid')
const router = require('express').Router
const jwt = require('jsonwebtoken')
const co = require('co')
const redis = require('../redis')
const {
  getQuestsListKey,
  getRecentQuestsKey
} = require('./util/redis-keys')

const questsRouter = router()

questsRouter.get('/', (req, res) => co(function * () {
  const recentQuests = yield redis.lrange(
    getRecentQuestsKey(),
    req.params.offset || 0,
    req.params.count || 10
  )

  global.console.log('recent quests === ', recentQuests)

  const pipeline = recentQuests.reduce((pipe, questKey) => {
    const userId = questKey.split(':')[0]

    return pipeline.lindex(getQuestsListKey(userId), 0)
  }, redis.multi())

  const results = yield pipeline.exec()
  global.console.log('pipeline results === ', results)

  const quests = results
    .map(questJSON => JSON.parse(questJSON))
    .filter((quest, idx) => {
      const recentGuid = recentQuests[idx].split(':')[1]

      return recentGuid === quest.guid
    })

  res.json(quests)
}).catch(err => {
  const log = req.app.locals.log

  log.error(err, 'error getting recent quests')
  global.console.error(err)

  res.status(400).json({success: false})
}))

questsRouter.post('/', (req, res) => co(function * () {
  const {userId} = yield jwt.verify(res.locals.token, global.config.appSecret)

  const guid = uuid.v4()
  const quest = {
    guid,
    id: req.body.id,
    name: req.body.name,
    description: req.body.description,
    imageUrl: req.body.imageUrl,
    upvotes: 1
  }

  yield redis.multi()
    .lpush(getQuestsListKey(userId), JSON.stringify(quest))
    .lpush(getRecentQuestsKey(), `${userId}:${guid}`)
    .exec()

  res.json(quest)
}).catch(err => {
  const log = req.app.local.log

  log.error(err, 'error creating quest')

  res.status(400).json({success: false})
}))

module.exports = questsRouter
