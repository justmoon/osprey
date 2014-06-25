class OspreyBase
  constructor: (@context, @settings, @logger, @container) ->
    unless @settings?
      @settings = {}

    @settings.handlers = []
    @context.disable 'x-powered-by'
    @checkSettings @settings

  checkSettings: (settings) ->
    @settings.enableValidations = true unless @settings.enableValidations?
    @settings.enableConsole = true unless @settings.enableConsole?
    @settings.consolePath = "/console" unless @settings.consolePath

  registerMiddlewares: (middlewares, context, settings, resources, uriTemplateReader, logger) ->
    for middleware in middlewares
      temp = new middleware context, settings, resources, uriTemplateReader, logger
      @context.use temp.exec

  # get: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'get', template: uriTemplate, handler: handler }

  # post: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'post', template: uriTemplate, handler: handler }

  # put: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'put', template: uriTemplate, handler: handler }

  # delete: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'delete', template: uriTemplate, handler: handler }

  # head: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'head', template: uriTemplate, handler: handler }

  # patch: (uriTemplate, handler) =>
  #   @settings.handlers.push { method: 'patch', template: uriTemplate, handler: handler }

module.exports = OspreyBase
