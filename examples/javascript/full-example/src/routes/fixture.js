var _ = require('lodash');

module.exports = function (api, db) {
  api.get('/fixture', function (req, res) {
    var result = _.clone(db.fixture, true);

    if (result.length === 0) {
      res.send(404);
    }

    res.send({
      fixture: result
    });
  });

  api.get('/fixture/:homeTeamId/:awayTeamId', function (req, res) {
    var result = _.find(db.fixture, {
      homeTeam: req.params.homeTeamId,
      awayTeam: req.params.awayTeamId
    });

    if (!result) {
      res.send(404);
      return;
    }

    res.send(result);
  });

  api.put('/fixture/:homeTeamId/:awayTeamId', function (req, res) {
    var date = new Date();
    var result = _.find(db.fixture, {
      homeTeam: req.params.homeTeamId,
      awayTeam: req.params.awayTeamId
    });

    if (result) {
      res.send(409);
      return;
    }

    // Check if the home team and the away team is the same
    if(req.params.homeTeamId === req.params.awayTeamId) {
      res.send(409);
      return;
    }

    // Check if the teams exists
    if (!_.find(db.teams, { id: req.params.homeTeamId }) || !_.find(db.teams, { id: req.params.awayTeamId })) {
      res.send(409);
      return;
    }

    db.fixture.push({
      homeTeam: req.params.homeTeamId.toUpperCase(),
      awayTeam: req.params.awayTeamId.toUpperCase(),
      homeTeamScore: req.body.homeTeamScore,
      awayTeamScore: req.body.awayTeamScore,
      date: date.toISOString()
    });

    res.send(204);
  });
};
