UriTemplateReader = require './uri-template-reader'
parser            = require './wrapper'
Osprey            = require './osprey'
UriTemplateReader = require './uri-template-reader'
logger            = require './utils/logger'
path              = require 'path'
express           = require 'express'
_                 = require 'lodash'

# Refactor
InvalidAcceptTypeError = require './errors/invalid-accept-type-error'
InvalidContentTypeError = require './errors/invalid-content-type-error'

exports.create = (settings) ->
  unless settings.ramlFile
    settings.ramlFile = path.join process.cwd(), '/src/assets/raml/api.raml'

  ospreyApp = express()
  osprey = new Osprey ospreyApp, settings, logger

  logger.setLevel settings.logLevel

  parser.loadRaml settings.ramlFile, logger, (wrapper) ->
    resources = wrapper.getResources()
    uriTemplateReader = new UriTemplateReader wrapper.getUriTemplates()

    # Extract to another class
    _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
      _.forEach uriTemplates, (uriTemplate) ->

        methodInfo = wrapper.getMethodInfo method, uriTemplate
        statusCode = _.first(Object.keys(methodInfo.responses)) || 200
        body = methodInfo.responses?[statusCode]?.body
        mimeTypes = if body then Object.keys(body) else []

        if mimeTypes.length
          # Register Accept Negotiations only if there are mime-types defined
          ospreyApp[method] uriTemplate, (req, res, next) ->
            supportedType = req.accepts(mimeTypes)
            throw new InvalidAcceptTypeError unless supportedType
            res.set 'Content-Type', supportedType
            next()

        # Register Content-Type Negotiations only if there are mime-types defined
        if method in ['patch', 'post', 'put']
          ospreyApp[method] uriTemplate, (req, res, next) ->
            isValid = false

            for value in mimeTypes
              console.log value
              if req.is(value)
                isValid = true
                break

            throw new InvalidContentTypeError unless isValid or not req.get('Content-Type')?

            next()

    osprey.load null, uriTemplateReader, resources

    # Register the console after Osprey has been loaded, since Osprey is
    # attached asynchronously after RAML is parsed. The first call to any
    # Express http method will mount the router and we don't want that to
    # occur until we actually can handle it with Osprey.
    osprey.registerConsole()

  osprey
