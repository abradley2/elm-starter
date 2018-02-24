exports.getAcccessTokenKey = function (sessionId) {
  return 'es:accesstoken' + sessionId
}

exports.getQuestsListKey = function (userId) {
  return `es:quests:user:${userId}`
}

exports.getRecentQuestsKey = function () {
  return 'es:quests:recent'
}

exports.getSuggestedSideQuestsKey = function (userId, questId) {
  return `es:suggested:${userId}:${questId}`
}

exports.getSideQuestsListKey = function (userId, questId) {
  return `es:sidequests:${userId}:${questId}`
}

Object.keys(module.exports).forEach(method => {
  module.exports[method] = (getKey => (...args) => {
    return `${global.config.redisKeysVersion}:${getKey(...args)}`
  })(module.exports[method])
})
