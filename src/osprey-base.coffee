class OspreyBase
  constructor: (@context, @settings, @logger) ->
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

module.exports = OspreyBase
