_ = require 'lodash'
validations = require '../middlewares/default-parameters'

module.exports =  (wrapper, ospreyApp, middleware) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
        defaultParametersHandler = `function defaultParametersHandler(req, res, next) {
          middleware.exec(req, res, next);
        }`

        ospreyApp.use uriTemplate, defaultParametersHandler
        # ospreyApp[method] uriTemplate, defaultParametersHandler
