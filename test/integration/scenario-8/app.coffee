express = require 'express'
path = require 'path'
osprey = require '../../../src/lib'

app = express()

app.use express.json()
app.use express.urlencoded()

api1 = osprey.create
  ramlFile: path.join(__dirname, 'api1.raml')
  enableMocks: false
  enableValidations: false
  enableConsole: false
  logLevel: 'off'

api1.mount '/api1', app

api1.describe (api1) ->
  api1.get '/overwrite', (req, res) ->
    res.send([{
      id: 1
      description: 'GET'
    }])

  api1.post '/overwrite', (req, res) ->
    res.status 201
    res.send { description: 'POST' }

  api1.head '/overwrite', (req, res) ->
    res.set 'header', 'HEAD'
    res.send 204

  api1.get '/overwrite/:id', (req, res) ->
    res.send { id: 1, description: 'GET' }

  api1.put '/overwrite/:id', (req, res) ->
    res.set 'header', 'PUT'
    res.send 204

  api1.patch '/overwrite/:id', (req, res) ->
    res.set 'header', 'PATCH'
    res.send 204

  api1.delete '/overwrite/:id', (req, res) ->
    res.set 'header', 'DELETE'
    res.send 204

api2 = osprey.create
  ramlFile: path.join(__dirname, 'api2.raml')
  enableMocks: false
  enableValidations: false
  enableConsole: false
  logLevel: 'off'

api2.mount '/api2', app

api2.describe (api2) ->
  api2.get '/overwrite', (req, res) ->
    res.send([{
      id: 1
      description: 'GET'
    }])

  api2.post '/overwrite', (req, res) ->
    res.status 201
    res.send { description: 'POST' }

  api2.head '/overwrite', (req, res) ->
    res.set 'header', 'HEAD'
    res.send 204

  api2.get '/overwrite/:id', (req, res) ->
    res.send { id: 1, description: 'GET' }

  api2.put '/overwrite/:id', (req, res) ->
    res.set 'header', 'PUT'
    res.send 204

  api2.patch '/overwrite/:id', (req, res) ->
    res.set 'header', 'PATCH'
    res.send 204

  api2.delete '/overwrite/:id', (req, res) ->
    res.set 'header', 'DELETE'
    res.send 204

module.exports = app
