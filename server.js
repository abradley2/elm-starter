const path = require('path')
const http = require('http')
const log = require('pino')()
const app = require('express')()
const pub = require('express').static
const api = require('./api')

app.use(
  pub(path.join(__dirname, 'public'))
)

app.use(api)

app.locals.log = log

global.logger = log

const server = http.createServer(function (req, res) {
  app(req, res)
})

server.listen(process.env.PORT || 5000, function () {
  log.info({name: 'server/start'}, `Server listening on port ${process.env.PORT || 5000}`)
})
