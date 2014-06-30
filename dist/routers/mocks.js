(function() {
  var _;

  _ = require('lodash');

  module.exports = function(wrapper, ospreyApp) {
    return _.forOwn(wrapper.getUriTemplatesByHttpMethod(), function(uriTemplates, method) {
      return _.forEach(uriTemplates, function(uriTemplate) {
        var body, handler, isOverridden, methodInfo, mimeTypes, mockHandler, parametersHandler, statusCode, _ref, _ref1;
        methodInfo = wrapper.getMethodInfo(method, uriTemplate);
        statusCode = _.first(Object.keys(methodInfo.responses || {})) || 200;
        body = (_ref = methodInfo.responses) != null ? (_ref1 = _ref[statusCode]) != null ? _ref1.body : void 0 : void 0;
        mimeTypes = body ? Object.keys(body) : [];
        parametersHandler = function parametersHandler(req, res, next) {
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
      };
        ospreyApp[method](uriTemplate, parametersHandler);
        isOverridden = function(ospreyApp, req) {
          var handlers, result;
          result = _.filter(ospreyApp.routes[req.method.toLowerCase()], function(value) {
            return value.path === req.route.path;
          });
          handlers = _.filter(result, function(value) {
            var name;
            name = _.first(value.callbacks).name;
            return name !== 'validationHandler' && name !== 'contentTypeNegotiationHandler' && name !== 'acceptNegotiationHandler' && name !== 'parametersHandler' && name !== 'defaultParametersHandler' && name !== 'mockHandler';
          });
          return handlers.length > 0;
        };
        if (method === 'get' || method === 'patch' || method === 'post' || method === 'put') {
          handler = function(req, res, next) {
            var mimeType, response, _ref2;
            if (isOverridden(ospreyApp, req)) {
              return next();
            } else {
              mimeType = _.first(mimeTypes);
              response = (body != null ? (_ref2 = body[mimeType]) != null ? _ref2.example : void 0 : void 0) || {};
              return res.status(statusCode).send(response);
            }
          };
          mockHandler = function mockHandler(req, res, next) {
          handler(req, res, next);
        };
          ospreyApp[method](uriTemplate, mockHandler);
        }
        if (method === 'delete' || method === 'head') {
          handler = function(req, res, next) {
            if (isOverridden(ospreyApp, req)) {
              return next();
            } else {
              return res.send(Number(statusCode));
            }
          };
          mockHandler = function mockHandler(req, res, next) {
          handler(req, res, next);
        };
          return ospreyApp[method](uriTemplate, mockHandler);
        }
      });
    });
  };

}).call(this);
