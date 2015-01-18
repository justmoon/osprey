(function() {
  var Osprey, UriTemplateReader, logger, parser, path;

  UriTemplateReader = require('./uri-template-reader');

  parser = require('./wrapper');

  Osprey = require('./osprey');

  UriTemplateReader = require('./uri-template-reader');

  logger = require('./utils/logger');

  path = require('path');

  exports.create = function(apiPath, context, settings) {
    var osprey;
    if (!settings.ramlFile) {
      settings.ramlFile = path.join(process.cwd(), '/src/assets/raml/api.raml');
    }
    osprey = new Osprey(apiPath, context, settings, logger);
    logger.setLevel(settings.logLevel);
    parser.loadRaml(settings.ramlFile, logger).then(function(wrapper) {
      var resources, schemas, uriTemplateReader;
      resources = wrapper.getResources();
      schemas = wrapper.getSchemas();
      uriTemplateReader = new UriTemplateReader(wrapper.getUriTemplates());
      osprey.load(null, uriTemplateReader, resources, schemas);
      return osprey.registerConsole();
    }).done();
    return osprey;
  };

}).call(this);
