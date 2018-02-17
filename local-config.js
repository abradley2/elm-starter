if (process.env.APP_SECRET) {
  module.exports = {
    appSecret: process.env.APP_SECRET,
    fbClientSecret: process.env.FB_CLIENT_SECRET,
    fbAppId: process.env.FB_APP_ID,
    fbRedirectUri: process.env.FB_REDIRECT_URI,
    redisUrl: process.env.REDIS_URL,
    redisKeysVersion: process.env.REDIS_KEYS_VERSION
  }
} else {
  module.exports = require('./config')
}
