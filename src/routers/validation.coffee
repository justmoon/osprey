_ = require 'lodash'
sanitize = require('raml-sanitize')()
validate = require('raml-validate')()
InvalidUriParameterError = require '../errors/invalid-uri-parameter-error'
InvalidQueryParameterError = require '../errors/invalid-query-parameter-error'
InvalidHeaderError = require '../errors/invalid-header-error'
InvalidFormParameterError = require '../errors/invalid-form-parameter-error'
InvalidBodyError = require '../errors/invalid-body-error'

libxml = require 'libxmljs'
SchemaValidator = require('jsonschema').Validator

methodInfoFor = (resource, httpMethod) ->
  if resource.methods?
    for method in resource.methods
      if method.method == httpMethod
        return method

  return null

module.exports =  (wrapper, ospreyApp) ->
  _.forOwn wrapper.getUriTemplatesByHttpMethod(), (uriTemplates, method) ->
    _.forEach uriTemplates, (uriTemplate) ->
        resource = wrapper.getResources()[uriTemplate]
        methodInfo = methodInfoFor resource, method

        uriParameterData = resource.uriParameters
        queryParametersData = methodInfo?.queryParameters
        headersData = methodInfo?.headers

        formParametersData = methodInfo.body?['multipart/form-data']
        formParametersData = methodInfo.body?['application/x-www-form-urlencoded'] unless formParametersData?
        formParametersData = formParametersData?.formParameters
        jsonBodyData = methodInfo.body?['application/json']?.schema
        xmlBodyData = methodInfo.body?['application/xml']?.schema || methodInfo.body?['text/xml']?.schema

        # Registering uri parameter validation
        if uriParameterData?
          validationHandler = `function validationHandler(req, res, next) {
            var validator = validate(uriParameterData);
            var sanitizer = sanitize(uriParameterData);

            if (!validator(sanitizer(req.params)).valid) {
              throw new InvalidUriParameterError();
            }
            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler

        # Registering query parameter validation
        if queryParametersData?
          validationHandler = `function validationHandler(req, res, next) {
            var validator = validate(queryParametersData);
            var sanitizer = sanitize(queryParametersData);

            if (!validator(sanitizer(req.query)).valid) {
              throw new InvalidQueryParameterError();
            }
            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler

        # Registering header validation
        if headersData?
          validationHandler = `function validationHandler(req, res, next) {
            var validator = validate(headersData);
            var sanitizer = sanitize(headersData);

            if (!validator(sanitizer(req.headers)).valid) {
              throw new InvalidHeaderError();
            }
            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler

        # Registering form parameter validation
        if formParametersData?
          validationHandler = `function validationHandler(req, res, next) {
            if (req.is('application/x-www-form-urlencoded') || req.is('multipart/form-data')) {
              var validator = validate(formParametersData);
              var sanitizer = sanitize(formParametersData);

              if (!validator(sanitizer(req.body)).valid) {
                throw new InvalidFormParameterError();
              }
            }

            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler

        # Registering json schema validation
        if jsonBodyData?
          schemaValidator = new SchemaValidator()

          validationHandler = `function validationHandler(req, res, next) {
            if (req.is('json')) {
              if (schemaValidator.validate(req.body, JSON.parse(jsonBodyData)).errors.length > 0) {
                throw new InvalidBodyError();
              }
            }

            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler

        # Registering xml schema validation
        if xmlBodyData?
          xsd = libxml.parseXmlString(xmlBodyData)

          validationHandler = `function validationHandler(req, res, next) {
            if (req.is('application/xml') || req.is('text/xml')) {
              if (req.rawBody) {
                xml = libxml.parseXmlString(req.rawBody)

                if(!xml.validate(xsd)) {
                  throw new InvalidBodyError();
                }
              }
            }

            next();
          }`

          ospreyApp[method] uriTemplate, validationHandler
