var express = require('express');
var path    = require('path');
var osprey  = require('osprey');
var app     = express();
var db      = { teams: [], fixture: [] };

app.use(express.json());
app.use(express.urlencoded());
app.use(express.logger('dev'));
app.set('port', process.env.PORT || 3000);

var api = module.exports = osprey.create('/api', app, {
  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
  logLevel: 'debug',
  enableMocks: false,
  enableConsole: false
});

api.describe(function (api) {
  // Loading routes
  require('./routes')(api, db);
})
.then(function (app) {
  if (!module.parent) {
    var port = app.get('port');
    app.listen(port);
    console.log('listening on port ' + port);
  }
});
