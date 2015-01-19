module.exports =
  InvalidAcceptTypeError: (err, req, res) ->
    res.send 406

  InvalidContentTypeError: (err, req, res) ->
    res.send 415

  InvalidUriParameterError: (err, req, res) ->
    res.send 400

  InvalidFormParameterError: (err, req, res) ->
    res.send 400

  InvalidQueryParameterError: (err, req, res) ->
    res.send 400

  InvalidHeaderError: (err, req, res) ->
    res.send 400

  InvalidBodyError: (err, req, res) ->
    res.status 400
    res.json error:
      id: "Invalid Body",
      message: err.message,
      validationErrors: err.validationErrors

  Error: (err, req, res) ->
    res.send 500
