var _ = require('lodash');

module.exports = function (api, db) {
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

    res.send({ teams: teams });
  });

  api.post('/teams', function (req, res) {
    req.body.id = req.body.name.slice(0, 3).toUpperCase();

    if (_.find(db.teams, { id: req.body.id })) {
      res.send(409);
      return;
    }

    db.teams.push(req.body);
    res.send(201);
  });

  api.get('/teams/:teamId', function (req, res) {
    var result = _.find(db.teams, { id: req.params.teamId });

    res.send(result || 404);
  });

  api.put('/teams/:teamId', function (req, res) {
    var result = _.find(db.teams, { id: req.params.teamId });

    if (result) {
      result.stadium  = req.body.stadium || result.stadium;
      result.homeCity = req.body.homeCity || result.homeCity;
      result.name     = req.body.name || result.name;

      console.log(db.teams);

      res.send(204);
      return;
    }

    res.send(404);
  });

  api.delete('/teams/:teamId', function (req, res) {
    var result = _.find(db.teams, { id: req.params.teamId });

    if (result) {
      db.teams = _.reject(db.teams, function (team) { return team.id === req.params.teamId; });
      res.send(204);
      return;
    }

    res.send(404);
  });
};
