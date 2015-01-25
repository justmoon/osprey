(function() {
  module.exports = {
    InvalidAcceptTypeError: function(err, req, res) {
      return res.status(406);
    },
    InvalidContentTypeError: function(err, req, res) {
      return res.status(415);
    },
    InvalidUriParameterError: function(err, req, res) {
      return res.status(400);
    },
    InvalidFormParameterError: function(err, req, res) {
      return res.status(400);
    },
    InvalidQueryParameterError: function(err, req, res) {
      return res.status(400);
    },
    InvalidHeaderError: function(err, req, res) {
      return res.status(400);
    },
    InvalidBodyError: function(err, req, res) {
      res.status(400);
      return res.json({
        error: {
          id: "Invalid Body",
          message: err.message,
          validationErrors: err.validationErrors
        }
      });
    },
    Error: function(err, req, res) {
      res.status(500);
      return res.json({
        error: {
          id: "Internal Error",
          message: err.message
        }
      });
    }
  };

}).call(this);
