(function() {
  var InvalidBodyError,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  InvalidBodyError = (function(_super) {
    __extends(InvalidBodyError, _super);

    function InvalidBodyError(message, validationErrors) {
      this.message = message;
      this.validationErrors = validationErrors;
      Error.captureStackTrace(this, this);
      this.name = "InvalidBodyError";
    }

    return InvalidBodyError;

  })(Error);

  module.exports = InvalidBodyError;

}).call(this);
