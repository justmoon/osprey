(function() {
  var validations, _;

  _ = require('lodash');

  validations = require('../middlewares/default-parameters');

  module.exports = function(wrapper, ospreyApp, middleware) {
    return _.forOwn(wrapper.getUriTemplatesByHttpMethod(), function(uriTemplates, method) {
      return _.forEach(uriTemplates, function(uriTemplate) {
        var defaultParametersHandler;
        defaultParametersHandler = function defaultParametersHandler(req, res, next) {
          middleware.exec(req, res, next);
        };
        return ospreyApp[method](uriTemplate, defaultParametersHandler);
      });
    });
  };

}).call(this);
