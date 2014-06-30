_ = require 'lodash'

module.exports =  (wrapper, ospreyApp) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
      methodInfo = wrapper.getMethodInfo method, uriTemplate
      statusCode = _.first(Object.keys(methodInfo.responses || {})) || 200
      body = methodInfo.responses?[statusCode]?.body
      mimeTypes = if body then Object.keys(body) else []

      # Set Default Headers
      parametersHandler = `function parametersHandler(req, res, next) {
        var name, value, responses, body, headers;

        headers = (responses = methodInfo.responses) != null ?
                  (body = responses[statusCode]) != null ?
                  body.headers : void 0 : void 0;

        for (name in headers) {
          value = headers[name];
          if (value["default"] != null) {
            res.set(name, value["default"]);
          }
        }

        next();
      }`

      # ospreyApp.use uriTemplate, parametersHandler
      ospreyApp[method] uriTemplate, parametersHandler

      isOverridden = (ospreyApp, req) ->
        result = _.filter ospreyApp.routes[req.method.toLowerCase()], (value) ->
            value.path == req.route.path

        handlers = _.filter result, (value) ->
          name = _.first(value.callbacks).name
          name != 'validationHandler' &&
          name != 'contentTypeNegotiationHandler' &&
          name != 'acceptNegotiationHandler' &&
          name != 'parametersHandler' &&
          name != 'defaultParametersHandler' &&
          name != 'mockHandler'

        return handlers.length > 0

      # Set Response
      if method in ['get', 'patch', 'post', 'put']
        handler = (req, res, next) ->
          if isOverridden(ospreyApp, req)
            next()
          else
            mimeType = _.first(mimeTypes)
            response = body?[mimeType]?.example || {}
            res.status(statusCode).send(response)

        mockHandler = `function mockHandler(req, res, next) {
          handler(req, res, next);
        }`

        # ospreyApp.use uriTemplate, mockHandler
        ospreyApp[method] uriTemplate, mockHandler

      # Set Response
      if method in ['delete', 'head']
        handler = (req, res, next) ->
          if isOverridden(ospreyApp, req)
            next()
          else
            res.send Number(statusCode)
        mockHandler = `function mockHandler(req, res, next) {
          handler(req, res, next);
        }`

        # ospreyApp.use uriTemplate, mockHandler
        ospreyApp[method] uriTemplate, mockHandler
