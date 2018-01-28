exports.getAcccessTokenKey = function (sessionId) {
  return 'es:accesstoken' + sessionId
}

exports.getQuestsListKey = function (userId) {
  return `es:quests:user:${userId}`
}

exports.getRecentQuestsKey = function () {
  return 'es:quests:recent'
}
