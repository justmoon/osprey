(function() {
  var ErrorHandler, errorDefaultSettings;

  errorDefaultSettings = require('../error-default-settings');

  ErrorHandler = (function() {
    function ErrorHandler(apiPath, context, settings, resources, schemas, uriTemplateReader, logger) {
      var key, value, _ref;
      this.apiPath = apiPath;
      this.context = context;
      this.settings = settings;
      this.resources = resources;
      this.schemas = schemas;
      this.uriTemplateReader = uriTemplateReader;
      this.logger = logger;
      this.logger.info('Osprey::ExceptionHandler has been initialized successfully');
      _ref = settings.exceptionHandler;
      for (key in _ref) {
        value = _ref[key];
        errorDefaultSettings[key] = value;
      }
    }

    ErrorHandler.prototype.exec = function(err, req, res, next) {
      var errorHandler;
      errorHandler = errorDefaultSettings[err.constructor.name];
      if (errorHandler != null) {
        return errorHandler(err, req, res, next);
      } else if (err) {
        throw err;
      } else {
        return next();
      }
    };

    return ErrorHandler;

  })();

  module.exports = ErrorHandler;

}).call(this);
