(function() {
  var InvalidBodyError, InvalidFormParameterError, InvalidHeaderError, InvalidQueryParameterError, InvalidUriParameterError, SchemaValidator, libxml, methodInfoFor, sanitize, validate, _;

  _ = require('lodash');

  sanitize = require('raml-sanitize')();

  validate = require('raml-validate')();

  InvalidUriParameterError = require('../errors/invalid-uri-parameter-error');

  InvalidQueryParameterError = require('../errors/invalid-query-parameter-error');

  InvalidHeaderError = require('../errors/invalid-header-error');

  InvalidFormParameterError = require('../errors/invalid-form-parameter-error');

  InvalidBodyError = require('../errors/invalid-body-error');

  libxml = require('libxmljs');

  SchemaValidator = require('jsonschema').Validator;

  methodInfoFor = function(resource, httpMethod) {
    var method, _i, _len, _ref;
    if (resource.methods != null) {
      _ref = resource.methods;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        method = _ref[_i];
        if (method.method === httpMethod) {
          return method;
        }
      }
    }
    return null;
  };

  module.exports = function(wrapper, ospreyApp) {
    return _.forOwn(wrapper.getUriTemplatesByHttpMethod(), function(uriTemplates, method) {
      return _.forEach(uriTemplates, function(uriTemplate) {
        var formParametersData, headersData, jsonBodyData, methodInfo, queryParametersData, resource, schemaValidator, uriParameterData, validationHandler, xmlBodyData, xsd, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
        resource = wrapper.getResources()[uriTemplate];
        methodInfo = methodInfoFor(resource, method);
        uriParameterData = resource.uriParameters;
        queryParametersData = methodInfo != null ? methodInfo.queryParameters : void 0;
        headersData = methodInfo != null ? methodInfo.headers : void 0;
        formParametersData = (_ref = methodInfo.body) != null ? _ref['multipart/form-data'] : void 0;
        if (formParametersData == null) {
          formParametersData = (_ref1 = methodInfo.body) != null ? _ref1['application/x-www-form-urlencoded'] : void 0;
        }
        formParametersData = formParametersData != null ? formParametersData.formParameters : void 0;
        jsonBodyData = (_ref2 = methodInfo.body) != null ? (_ref3 = _ref2['application/json']) != null ? _ref3.schema : void 0 : void 0;
        xmlBodyData = ((_ref4 = methodInfo.body) != null ? (_ref5 = _ref4['application/xml']) != null ? _ref5.schema : void 0 : void 0) || ((_ref6 = methodInfo.body) != null ? (_ref7 = _ref6['text/xml']) != null ? _ref7.schema : void 0 : void 0);
        if (uriParameterData != null) {
          validationHandler = function validationHandler(req, res, next) {
            var validator = validate(uriParameterData);
            var sanitizer = sanitize(uriParameterData);

            if (!validator(sanitizer(req.params)).valid) {
              throw new InvalidUriParameterError();
            }
            next();
          };
          ospreyApp[method](uriTemplate, validationHandler);
        }
        if (queryParametersData != null) {
          validationHandler = function validationHandler(req, res, next) {
            var validator = validate(queryParametersData);
            var sanitizer = sanitize(queryParametersData);

            if (!validator(sanitizer(req.query)).valid) {
              throw new InvalidQueryParameterError();
            }
            next();
          };
          ospreyApp[method](uriTemplate, validationHandler);
        }
        if (headersData != null) {
          validationHandler = function validationHandler(req, res, next) {
            var validator = validate(headersData);
            var sanitizer = sanitize(headersData);

            if (!validator(sanitizer(req.headers)).valid) {
              throw new InvalidHeaderError();
            }
            next();
          };
          ospreyApp[method](uriTemplate, validationHandler);
        }
        if (formParametersData != null) {
          validationHandler = function validationHandler(req, res, next) {
            if (req.is('application/x-www-form-urlencoded') || req.is('multipart/form-data')) {
              var validator = validate(formParametersData);
              var sanitizer = sanitize(formParametersData);

              if (!validator(sanitizer(req.body)).valid) {
                throw new InvalidFormParameterError();
              }
            }

            next();
          };
          ospreyApp[method](uriTemplate, validationHandler);
        }
        if (jsonBodyData != null) {
          schemaValidator = new SchemaValidator();
          validationHandler = function validationHandler(req, res, next) {
            if (req.is('json')) {
              if (schemaValidator.validate(req.body, JSON.parse(jsonBodyData)).errors.length > 0) {
                throw new InvalidBodyError();
              }
            }

            next();
          };
          ospreyApp[method](uriTemplate, validationHandler);
        }
        if (xmlBodyData != null) {
          xsd = libxml.parseXmlString(xmlBodyData);
          validationHandler = function validationHandler(req, res, next) {
            if (req.is('application/xml') || req.is('text/xml')) {
              if (req.rawBody) {
                xml = libxml.parseXmlString(req.rawBody)

                if(!xml.validate(xsd)) {
                  throw new InvalidBodyError();
                }
              }
            }

            next();
          };
          return ospreyApp[method](uriTemplate, validationHandler);
        }
      });
    });
  };

}).call(this);
