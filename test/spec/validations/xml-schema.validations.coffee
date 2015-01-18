parser = require '../../../src/wrapper'
Validation = require '../../../src/middlewares/validation'
should = require 'should'
Request = require('../../mocks/server').request
Logger = require '../../mocks/logger'
UriTemplateReader = require '../../../src/uri-template-reader'

describe 'OSPREY VALIDATIONS - XML SCHEMA', =>
  before () =>
    parser.loadRaml "./test/assets/validations.xml-schema.raml", new Logger, (wrapper) =>
      @resources = wrapper.getResources()
      templates = wrapper.getUriTemplates()
      @uriTemplateReader = new UriTemplateReader templates

  it 'Should be correctly validated if request body is ok and content-type is application/xml', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/xml'
    req.addBody '<?xml version="1.0" ?><league><name>test</name></league>'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should be correctly validated if request body is ok and content-type is text/xml', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'text/xml'
    req.addBody '<?xml version="1.0" ?><league><name>test</name></league>'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should be correctly validated if request body is ok and content-type is [something]+xml', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/test+xml'
    req.addBody '<?xml version="1.0" ?><league><name>test</name></league>'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should throw an exception if request body is incorrect', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/xml'
    req.addBody '<?xml version="1.0" ?><league></league>'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.throw()

  it 'Should throw an exception if request body is empty', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/xml'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should not validate if content-type is not application/xml nor text/xml', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'text/plain'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()
