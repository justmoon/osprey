express = require 'express'
path = require 'path'
osprey = require '../../../src/lib'

app = express()

app.use express.json()
app.use express.urlencoded()
app.use '/api',  osprey.create '/api', app,
  ramlFile: path.join(__dirname, 'api.raml')
  enableMocks: true
  enableValidations: false
  enableConsole: false
  logLevel: 'off'

module.exports = app
