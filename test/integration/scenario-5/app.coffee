express = require 'express'
path = require 'path'
osprey = require '../../../src/lib'
xmlparser = require 'express-xml-bodyparser'
_ = require 'lodash'

app = express()

app.use xmlparser()
app.use express.json()
app.use express.urlencoded()

api = osprey.create
  ramlFile: path.join(__dirname, 'api.raml')
  enableMocks: true
  enableValidations: true
  enableConsole: false
  logLevel: 'off'

api.mount '/api', app

api.describe (api) ->
  api.get '/all', (req, res) ->
    res.send([{
      id: 1
      description: 'GET'
    }])

  api.post '/all', (req, res) ->
    res.status 201
    res.send { description: 'POST' }

  api.head '/all', (req, res) ->
    res.set 'header', 'HEAD'
    res.send 204

  api.get '/all/:id', (req, res) ->
    res.send { id: 1, description: 'GET' }

  api.put '/all/:id', (req, res) ->
    res.set 'header', 'PUT'
    res.send 204

  api.patch '/all/:id', (req, res) ->
    res.set 'header', 'PATCH'
    res.send 204

  api.delete '/all/:id', (req, res) ->
    res.set 'header', 'DELETE'
    res.send 204

  _.forEach api.routes.get, (obj) ->
      console.log obj.path
      console.log obj.callbacks

module.exports = app
