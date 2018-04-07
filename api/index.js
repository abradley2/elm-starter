const path = require('path')
const router = require('express').Router
const cors = require('cors')
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser')
const fileUpload = require('express-fileupload')

global.config = require('../local-config.js')

global.config.uploadDir = path.join(__dirname, '../public/uploads')

const api = router()
const sessionCorsConfig = process.env.NODE_ENV === 'development' ?
  {origin: 'http://localhost:8000', credentials: true} :
  {origin: false}

api.use(fileUpload({
  safeFileNames: true,
  abortOnLimit: true,
  preserveExtension: true,
  limits: {fileSize: 2 * 1024 * 1024}
}))
api.use(cookieParser())
api.use(bodyParser.json())
api.use(cors())
api.use((req, res, next) => {
  res.locals.token = req.cookies.token
  next()
})
api.use(
  '/session',
  cors(sessionCorsConfig),
  require('./routes/session')
)
api.use('/quests', require('./routes/quests'))
api.use('/sidequests', require('./routes/sidequests'))
api.use('/upload', require('./routes/upload'))

module.exports = api
