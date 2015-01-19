class InvalidBodyError extends Error
  constructor: (@message, @validationErrors) ->
    Error.captureStackTrace(@,@)
    @name = "InvalidBodyError"

module.exports = InvalidBodyError
