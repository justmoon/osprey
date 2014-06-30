(function() {
  var InvalidAcceptTypeError, InvalidContentTypeError, _;

  InvalidAcceptTypeError = require('../errors/invalid-accept-type-error');

  InvalidContentTypeError = require('../errors/invalid-content-type-error');

  _ = require('lodash');

  module.exports = function(wrapper, ospreyApp) {
    return _.forOwn(wrapper.getUriTemplatesByHttpMethod(), function(uriTemplates, method) {
      return _.forEach(uriTemplates, function(uriTemplate) {
        var acceptNegotiationHandler, body, contenTypes, contentTypeNegotiationHandler, handler, methodInfo, mimeTypes, statusCode, _ref, _ref1;
        methodInfo = wrapper.getMethodInfo(method, uriTemplate);
        statusCode = _.first(Object.keys(methodInfo.responses || {})) || 200;
        body = (_ref = methodInfo.responses) != null ? (_ref1 = _ref[statusCode]) != null ? _ref1.body : void 0 : void 0;
        mimeTypes = body ? Object.keys(body) : [];
        contenTypes = methodInfo.body ? Object.keys(methodInfo.body) : [];
        if (mimeTypes.length) {
          if (method === 'get' || method === 'patch' || method === 'post' || method === 'put') {
            acceptNegotiationHandler = function acceptNegotiationHandler(req, res, next) {
            var supportedType = req.accepts(mimeTypes);
            supportedType = req.accepts(mimeTypes);
            if (!supportedType) {
              throw new InvalidAcceptTypeError();
            }
            res.set('Content-Type', supportedType);
            next();
          };
            ospreyApp[method](uriTemplate, acceptNegotiationHandler);
          }
        }
        if (method === 'patch' || method === 'post' || method === 'put') {
          handler = function(req, res, next) {
            var isValid, value, _i, _len;
            isValid = false;
            for (_i = 0, _len = contenTypes.length; _i < _len; _i++) {
              value = contenTypes[_i];
              if (req.is(value)) {
                isValid = true;
                break;
              }
            }
            if (!(isValid || (req.get('Content-Type') == null))) {
              throw new InvalidContentTypeError;
            }
            return next();
          };
          contentTypeNegotiationHandler = function contentTypeNegotiationHandler(req, res, next) {
            handler(req, res, next);
          };
          return ospreyApp[method](uriTemplate, contentTypeNegotiationHandler);
        }
      });
    });
  };

}).call(this);
