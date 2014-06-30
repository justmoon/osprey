UriTemplateReader = require './uri-template-reader'
parser            = require './wrapper'
Osprey            = require './osprey'
UriTemplateReader = require './uri-template-reader'
logger            = require './utils/logger'
path              = require 'path'
express           = require 'express'

conneg            = require './routers/conneg'
mocks             = require './routers/mocks'
validation        = require './routers/validation'

# TODO: Refactor
dpMiddleware      = require './middlewares/default-parameters'
dp                = require './routers/default-parameters'

exports.create = (settings) ->
  unless settings.ramlFile
    settings.ramlFile = path.join process.cwd(), '/src/assets/raml/api.raml'

  ospreyApp = express()
  osprey = new Osprey ospreyApp, settings, logger

  logger.setLevel settings.logLevel

  parser.loadRaml settings.ramlFile, logger, (wrapper) ->
    resources = wrapper.getResources()
    uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

    # Loading conneg handler
    conneg wrapper, ospreyApp

    # Loading validations handlers
    if settings.enableValidations
      validation wrapper, ospreyApp

    # Loading defaul parameters handler
    middleware = new dpMiddleware(null, null, wrapper.getResources(), uriTemplateReader, logger)
    dp wrapper, ospreyApp, middleware

    # Loading mocks handlers
    if settings.enableMocks
      mocks wrapper, ospreyApp

    osprey.load null, uriTemplateReader, resources

    # Register the console after Osprey has been loaded, since Osprey is
    # attached asynchronously after RAML is parsed. The first call to any
    # Express http method will mount the router and we don't want that to
    # occur until we actually can handle it with Osprey.
    osprey.registerConsole()

  osprey
