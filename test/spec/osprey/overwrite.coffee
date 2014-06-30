Osprey = require '../../../src/osprey'
parser = require '../../../src/wrapper'
UriTemplateReader = require '../../../src/uri-template-reader'
should = require 'should'
Logger = require '../../mocks/logger'
express = require 'express'

describe 'OSPREY - OVERWRITE', =>
  it 'Should be able to overwrite an existing resource - GET', (done) ->
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", logger, (wrapper) ->
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.get '/resource', (req, res) ->

      # Assert
      api.routes.get.should.have.lengthOf 1
      api.routes.get[0].path.should.eql '/resource'
      done()

  it 'Should be able to overwrite an existing resource - POST', (done) ->
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.post '/resource', (req, res) ->

      # Assert
      api.routes.post.should.have.lengthOf 1
      api.routes.post[0].path.should.eql '/resource'
      done()

  it 'Should be able to overwrite an existing resource - PUT', (done) ->
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.put '/resource', (req, res) ->

      # Assert
      api.routes.put.should.have.lengthOf 1
      api.routes.put[0].path.should.eql '/resource'
      done()

  it 'Should be able to overwrite an existing resource - DELETE', (done) ->
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.delete '/resource', (req, res) ->

      # Assert
      api.routes.delete.should.have.lengthOf 1
      api.routes.delete[0].path.should.eql '/resource'
      done()

  it 'Should be able to overwrite an existing resource - HEAD', () =>
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.head '/resource', (req, res) ->

      # Assert
      api.routes.head.should.have.lengthOf 1
      api.routes.head[0].path.should.eql '/resource'
      done()

  it 'Should be able to overwrite an existing resource - PATCH', () =>
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

      # Act
      osprey.load null, uriTemplateReader, wrapper.getResources()
      osprey.mount '/api', app

    osprey.describe (api) ->
      api.patch '/resource', (req, res) ->

      # Assert
      api.routes.patch.should.have.lengthOf 1
      api.routes.patch[0].path.should.eql '/resource'
      done()
