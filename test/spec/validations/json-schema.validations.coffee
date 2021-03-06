parser = require '../../../src/wrapper'
Validation = require '../../../src/middlewares/validation'
should = require 'should'
Request = require('../../mocks/server').request
Logger = require '../../mocks/logger'
UriTemplateReader = require '../../../src/uri-template-reader'

describe 'OSPREY VALIDATIONS - JSON SCHEMA', =>
  before () =>
    parser.loadRaml("./test/assets/validations.json-schema.raml", new Logger)
    .then (wrapper) =>
      @resources = wrapper.getResources()
      @schemas = wrapper.getSchemas()
      templates = wrapper.getUriTemplates()
      @uriTemplateReader = new UriTemplateReader templates

  it 'Should be correctly validated if request body is ok and content-type is application/json', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'
    req.addBody { id: 'aaa', foo: "bar" }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should be correctly validated if request body is ok and content-type is [something]+json', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/test+json'
    req.addBody { id: 'aaa', foo: "bar" }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should be correctly validated if request body is empty and content-type is [something]+json', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/test+json'
    req.addBody {}

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should throw an exception if request body is incorrect', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'
    req.addBody { id: 'a' }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.throw()

  it 'Should throw an exception if request body does not match ref\'d schema', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'
    req.addBody { id: 'a', foo: "derp" }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.throw()

  it 'Should not validate if content-type is not application/json', () =>
    # Arrange
    resource = @resources['/resources']
    req = new Request 'POST', '/api/resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'text/plain'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should be correctly validated against external schema if request body is ok', () =>
    # Arrange
    resource = @resources['/external-resources']
    req = new Request 'POST', '/api/external-resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'
    req.addBody { "example": "foo" }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()

  it 'Should not validate against external schema if field is missing', () =>
    # Arrange
    resource = @resources['/external-resources']
    req = new Request 'POST', '/api/external-resources'
    validation = new Validation '/api', {}, {}, @resources, @schemas, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'
    req.addBody { "exomple": "foo" }

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.throw()
