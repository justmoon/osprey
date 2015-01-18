ramlParser = require 'raml-parser'
Promise = require 'bluebird'

extend = (dest, sources...) ->
  for source in sources
    for key, value of source
      dest[key] = value

  dest

class ParserWrapper
  constructor: (data) ->
    @raml = data
    @resources = {}
    @schemas = {}
    @_generateResources()
    @_generateSchemas()

  getResources: ->
    @resources

  getUriTemplates: ->
    templates = []

    for key, resource of @resources
      templates.push { uriTemplate: key }

    templates

  getResourcesList: ->
    resourceList = []
    for key, resource of @resources
      resourceCopy = clone resource
      resourceCopy.uri = key
      resourceList.push resourceCopy
    resourceList

  getSchemas: ->
    @schemas

  getProtocols: ->
    @raml.protocols

  getSecuritySchemes: ->
    @raml.securitySchemes

  getRaml: ->
    @raml

  _generateResources: ->
    if @raml.resources?
      for resource in @raml.resources
        @_processResource resource, @resources

  _processResource: (resource, resourceMap, uri) ->
    if not uri?
      uri = resource.relativeUri

    if resource.resources?
      for child in resource.resources
        # Update the child uri parameters by extending the parents.
        child.uriParameters = extend({}, resource.uriParameters, child.uriParameters)

        # Recursively process resource objects.
        this._processResource child, resourceMap, uri + child.relativeUri

    uriKey = uri.replace /{(.*?)}/g,":$1"
    resourceMap[uriKey] = clone resource
    delete resourceMap[uriKey].relativeUri
    delete resourceMap[uriKey]?.resources

  _generateSchemas: ->
    if @raml.schemas?
      for schema in @raml.schemas
        @_processSchema schema, @schemas

  _processSchema: (schema, schemaMap) ->
    for schemaId of schema
      schemaMap[schemaId] = schema[schemaId]

clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime())

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags)

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance

ramlLoader = (filePath, logger) ->
  return new Promise((resolve, reject) ->
    ramlParser.loadFile(filePath).then(
      (data) ->
        logger.info 'RAML successfully loaded'
        resolve(new ParserWrapper data)
      ,(error) ->
        logger.error "Error when parsing RAML. Message: #{error.message}, Line: #{error.problem_mark.line}, Column: #{error.problem_mark.column}"
        reject(error)
    )
  )

exports.loadRaml = ramlLoader
