express = require 'express'
path = require 'path'
osprey = require '../../../src/lib'

app1 = express()
app2 = express()

app1.use express.json()
app1.use express.urlencoded()
app1.use '/app2', app2

api1 = osprey.create
  ramlFile: path.join(__dirname, 'api.raml')
  enableMocks: true
  enableValidations: false
  enableConsole: true
  logLevel: 'off'

api1.mount '/api', app1

api1.describe (api1) ->
  api1.get '/miscellaneous', (req, res) ->
    throw new Error()

api2 = osprey.create
  ramlFile: path.join(__dirname, 'api.raml')
  enableMocks: true
  enableValidations: false
  enableConsole: true
  logLevel: 'off'

api2.mount '/api', app2

module.exports = app1
