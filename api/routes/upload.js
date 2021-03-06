const path = require('path')
const fs = require('fs')
const router = require('express').Router
const co = require('co')
const jwt = require('jsonwebtoken')
const shortId = require('shortid')

const uploadRouter = router()

const uploadDirReady = co(function * () {
  const dirFound = yield new Promise(resolve => {
    fs.access(global.config.uploadDir, err => {
      resolve(!err)
    })
  })

  if (dirFound) {
    return
  }

  yield new Promise((resolve, reject) => {
    fs.mkdir(global.config.uploadDir, err => {
      if (err) {
        reject(err)
      }
      resolve()
    })
  })
})

uploadRouter.post('/', (req, res) => co(function * () {
  yield uploadDirReady

  const file = req.files.file
  if (!file) {
    res.status(400).send('no file found')
  }

  const {userId} = yield jwt.verify(res.locals.token, global.config.appSecret)

  const fileExt = file.name.split('.').pop()
  const fileName = shortId.generate() + '.' + fileExt
  const userDir = path.join(global.config.uploadDir, '/' + userId)

  const dirFound = yield new Promise(resolve => {
    fs.access(userDir, fs.constants.R_OK, err => {
      resolve(!err)
    })
  })

  if (!dirFound) {
    yield new Promise((resolve, reject) => {
      fs.mkdir(userDir, err => {
        if (err) {
          reject(err)
        }
        resolve()
      })
    })
  }

  yield file.mv(path.join(global.config.uploadDir, '/' + userId, '/' + fileName))

  res.json({success: true, file: '/uploads/' + userId + '/' + fileName})
}).catch(err => {
  global.console.error(err)
  global.logger.error(err.message, 'upload error')

  res.status(400).json({
    success: false
  })
}))

module.exports = uploadRouter
