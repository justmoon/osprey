InvalidAcceptTypeError  = require '../errors/invalid-accept-type-error'
InvalidContentTypeError = require '../errors/invalid-content-type-error'
_                       = require 'lodash'

module.exports =  (wrapper, ospreyApp) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
      methodInfo = wrapper.getMethodInfo method, uriTemplate
      statusCode = _.first(Object.keys(methodInfo.responses || {})) || 200
      body = methodInfo.responses?[statusCode]?.body
      mimeTypes = if body then Object.keys(body) else []
      contenTypes = if methodInfo.body then Object.keys(methodInfo.body) else []

      # Register Accept Negotiations only if there are mime-types defined
      if mimeTypes.length
        if method in ['get', 'patch', 'post', 'put']
          acceptNegotiationHandler = `function acceptNegotiationHandler(req, res, next) {
            if (req.method.toLowerCase() === method) {
              var supportedType = req.accepts(mimeTypes);
              supportedType = req.accepts(mimeTypes);
              if (!supportedType) {
                throw new InvalidAcceptTypeError();
              }
              res.set('Content-Type', supportedType);
            }

            next();
          }`

          ospreyApp.use uriTemplate, acceptNegotiationHandler
          # ospreyApp[method] uriTemplate, acceptNegotiationHandler

      # Register Content-Type Negotiations only if there are mime-types defined
      if method in ['patch', 'post', 'put']
        handler = (req, res, next) ->
          if req.method.toLowerCase() == method
            isValid = false

            for value in contenTypes
              if req.is(value)
                isValid = true
                break

            throw new InvalidContentTypeError unless isValid or not req.get('Content-Type')?

          next()
        contentTypeNegotiationHandler = `function contentTypeNegotiationHandler(req, res, next) {
            handler(req, res, next);
          }`

        ospreyApp.use uriTemplate, contentTypeNegotiationHandler
        # ospreyApp[method] uriTemplate, contentTypeNegotiationHandler
