(function() {
  var OspreyBase;

  OspreyBase = (function() {
    function OspreyBase(context, settings, logger) {
      this.context = context;
      this.settings = settings;
      this.logger = logger;
      if (this.settings == null) {
        this.settings = {};
      }
      this.settings.handlers = [];
      this.context.disable('x-powered-by');
      this.checkSettings(this.settings);
    }

    OspreyBase.prototype.checkSettings = function(settings) {
      if (this.settings.enableValidations == null) {
        this.settings.enableValidations = true;
      }
      if (this.settings.enableConsole == null) {
        this.settings.enableConsole = true;
      }
      if (!this.settings.consolePath) {
        return this.settings.consolePath = "/console";
      }
    };

    OspreyBase.prototype.registerMiddlewares = function(middlewares, context, settings, resources, uriTemplateReader, logger) {
      var middleware, temp, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = middlewares.length; _i < _len; _i++) {
        middleware = middlewares[_i];
        temp = new middleware(context, settings, resources, uriTemplateReader, logger);
        _results.push(this.context.use(temp.exec));
      }
      return _results;
    };

    return OspreyBase;

  })();

  module.exports = OspreyBase;

}).call(this);
