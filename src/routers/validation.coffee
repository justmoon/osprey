_ = require 'lodash'
validations = require '../middlewares/validation'

module.exports =  (wrapper, ospreyApp, middleware) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
        # Make it real javascript
        validationHandler = `function validationHandler(req, res, next) {
          middleware.exec(req, res, next);
        }`

        ospreyApp[method] uriTemplate, validationHandler
