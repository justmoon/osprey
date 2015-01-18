parser = require '../../../../src/wrapper'
Validation = require '../../../../src/middlewares/validation'
should = require 'should'
Request = require('../../../mocks/server').request
Logger = require '../../../mocks/logger'
UriTemplateReader = require '../../../../src/uri-template-reader'

describe 'OSPREY VALIDATIONS - URI PARAMETER - TYPE - BOOLEAN', =>
  before () =>
    parser.loadRaml "./test/assets/validations.uri-parameters.raml", new Logger, (wrapper) =>
      @resources = wrapper.getResources()
      templates = wrapper.getUriTemplates()
      @uriTemplateReader = new UriTemplateReader templates

  it 'Should throw an exception if the value type is incorrect', () =>
    # Arrange
    resource = @resources['/boolean/:id']
    req = new Request 'GET', '/api/boolean/aa'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.throw()

  it 'Should be correctly validated if the type is valid', () =>
    # Arrange
    resource = @resources['/boolean/:id']
    req = new Request 'GET', '/api/boolean/true'
    validation = new Validation '/api', {}, {}, @resources, {}, @uriTemplateReader, new Logger

    req.addHeader 'content-type', 'application/json'

    # Assert
    ( ->
      validation.validateRequest resource, req
    ).should.not.throw()
