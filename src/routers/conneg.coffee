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
          ospreyApp[method] uriTemplate, (req, res, next) ->
            supportedType = req.accepts(mimeTypes)
            throw new InvalidAcceptTypeError unless supportedType
            res.set 'Content-Type', supportedType
            next()

      # Register Content-Type Negotiations only if there are mime-types defined
      if method in ['patch', 'post', 'put']
        ospreyApp[method] uriTemplate, (req, res, next) ->
          isValid = false

          for value in contenTypes
            if req.is(value)
              isValid = true
              break

          throw new InvalidContentTypeError unless isValid or not req.get('Content-Type')?
          next()
