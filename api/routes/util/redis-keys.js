exports.getAcccessTokenKey = function (sessionId) {
  return 'es:accesstoken' + sessionId
}

exports.getQuestsListKey = function (userId) {
  return `es:quests:user:${userId}`
}

exports.getRecentQuestsKey = function () {
  return 'es:quests:recent'
}

Object.keys(module.exports).forEach(method => {
  module.exports[method] = (getKey => (...args) => {
    return `${global.config.redisKeysVersion}:${getKey(...args)}`
  })(module.exports[method])
})
