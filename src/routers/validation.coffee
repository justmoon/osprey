_ = require 'lodash'
validations = require '../middlewares/validation'

module.exports =  (wrapper, ospreyApp, middleware) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
        ospreyApp[method] uriTemplate, (req, res, next) ->
          middleware.exec req, res, next
