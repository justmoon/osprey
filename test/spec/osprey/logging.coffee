Osprey = require '../../../src/osprey'
parser = require '../../../src/wrapper'
UriTemplateReader = require '../../../src/uri-template-reader'
should = require 'should'
Logger = require '../../mocks/logger'
express = require 'express'

describe 'OSPREY - LOGGING', =>
  before () =>
    parser.loadRaml "./test/assets/well-formed.raml", new Logger, (wrapper) =>
      @resources = wrapper.getResources()
      templates = wrapper.getUriTemplates()
      @uriTemplateReader = new UriTemplateReader templates

  it 'Should make a log entry informing which modules were initialized', () =>
    # Arrange
    logger = new Logger
    app = express()
    osprey = new Osprey express(), {}, logger

    # Act
    osprey.load null, @uriTemplateReader, @resources
    osprey.registerConsole()
    osprey.mount '/api', app

    osprey.describe (api) ->
      # Assert
      logger.infoMessages.should.have.lengthOf 2
      # logger.infoMessages[0].should.eql 'Osprey::DefaultParameters has been initialized successfully'
      logger.infoMessages[0].should.eql 'Osprey::ExceptionHandler has been initialized successfully'
      # logger.infoMessages[1].should.eql 'Osprey::Validations has been initialized successfully'
      # logger.infoMessages[2].should.eql 'Osprey::Router has been initialized successfully'
      logger.infoMessages[1].should.eql 'Osprey::APIConsole has been initialized successfully listening at /api/console'
