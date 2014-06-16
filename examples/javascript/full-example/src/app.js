var express = require('express');
var path    = require('path');
var osprey  = require('osprey');
var app     = module.exports = express();
var _       = require('lodash');
var db      = { teams: [] };

app.use(express.json());
app.use(express.urlencoded());
app.use(express.logger('dev'));
app.set('port', process.env.PORT || 3000);

var api = osprey.create('/api', app, {
  ramlFile: path.join(__dirname, '/assets/raml/api.raml'),
  logLevel: 'debug',
  enableMocks: true
});

api.describe(function (api) {
  api.get('/teams', function (req, res) {
    var city = req.query.city;
    var teams = db.teams;

    if (city) {
      teams = _.filter(db.teams, function (team) {
        return team.homeCity.toLowerCase() === city.toLowerCase();
      });
    }

    if (teams.length === 0) {
      res.send(404);
    }

    res.send(teams);
  });

  api.post('/teams', function (req, res) {
    // Validations for duplicates
    req.body.id = req.body.name.slice(0, 3).toUpperCase();
    db.teams.push(req.body);
    res.send(201);
  });
})
.then(function (app) {
  if (!module.parent) {
    var port = app.get('port');
    app.listen(port);
    console.log('listening on port ' + port);
  }
});
