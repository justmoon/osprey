_ = require 'lodash'

module.exports =  (wrapper, ospreyApp) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
      console.log ospreyApp.routes.get
      methodInfo = wrapper.getMethodInfo method, uriTemplate
      statusCode = _.first(Object.keys(methodInfo.responses || {})) || 200
      body = methodInfo.responses?[statusCode]?.body
      mimeTypes = if body then Object.keys(body) else []

      # Set Default Headers
      ospreyApp[method] uriTemplate, (req, res, next) ->
        for name, value of methodInfo.responses?[statusCode]?.headers
          if value.default?
            res.set name, value.default
        next()

      # Set Response
      if method in ['get', 'patch', 'post', 'put']
        ospreyApp[method] uriTemplate, (req, res, next) ->
          mimeType = _.first(mimeTypes)
          response = body?[mimeType]?.example || {}
          res.status(statusCode).send(response)

      # Set Response
      if method in ['delete', 'head']
        ospreyApp[method] uriTemplate, (req, res, next) ->
          res.send Number(statusCode)
