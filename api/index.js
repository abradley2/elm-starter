const path = require('path')
const router = require('express').Router
const cors = require('cors')
const bodyParser = require('body-parser')
const fileUpload = require('express-fileupload')

global.config = require('../local-config.js')

global.config.uploadDir = path.join(__dirname, '../public/uploads')

const api = router()

api.use(fileUpload({
  safeFileNames: true,
  abortOnLimit: true,
  preserveExtension: true,
  limits: {fileSize: 2 * 1024 * 1024}
}))

api.use(bodyParser.json())
api.use(cors())
api.use((req, res, next) => {
  if (req.headers.authorization) {
    res.locals.token = req.headers.authorization.split(' ').pop()
  }
  next()
})
api.use('/session', require('./routes/session'))
api.use('/quests', require('./routes/quests'))
api.use('/upload', require('./routes/upload'))

module.exports = api
