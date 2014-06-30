(function() {
  var Osprey, UriTemplateReader, conneg, dp, dpMiddleware, express, logger, mocks, parser, path, validation;

  UriTemplateReader = require('./uri-template-reader');

  parser = require('./wrapper');

  Osprey = require('./osprey');

  UriTemplateReader = require('./uri-template-reader');

  logger = require('./utils/logger');

  path = require('path');

  express = require('express');

  conneg = require('./routers/conneg');

  mocks = require('./routers/mocks');

  validation = require('./routers/validation');

  dpMiddleware = require('./middlewares/default-parameters');

  dp = require('./routers/default-parameters');

  exports.create = function(settings) {
    var osprey, ospreyApp;
    if (!settings.ramlFile) {
      settings.ramlFile = path.join(process.cwd(), '/src/assets/raml/api.raml');
    }
    ospreyApp = express();
    osprey = new Osprey(ospreyApp, settings, logger);
    logger.setLevel(settings.logLevel);
    parser.loadRaml(settings.ramlFile, logger, function(wrapper) {
      var middleware, resources, uriTemplateReader;
      resources = wrapper.getResources();
      uriTemplateReader = new UriTemplateReader(wrapper.getUriTemplates());
      conneg(wrapper, ospreyApp);
      if (settings.enableValidations) {
        validation(wrapper, ospreyApp);
      }
      middleware = new dpMiddleware(null, null, wrapper.getResources(), uriTemplateReader, logger);
      dp(wrapper, ospreyApp, middleware);
      if (settings.enableMocks) {
        mocks(wrapper, ospreyApp);
      }
      osprey.load(null, uriTemplateReader, resources);
      return osprey.registerConsole();
    });
    return osprey;
  };

}).call(this);
