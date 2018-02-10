const Redis = require('ioredis')

const redis = global.config.redisUrl ? new Redis(global.config.redisUrl) : new Redis()

module.exports = redis
