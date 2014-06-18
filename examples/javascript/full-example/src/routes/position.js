var _ = require('lodash');

module.exports = function (api, db) {
  api.get('/positions', function (req, res) {
    var result   = {}, positions = [];
    var position = 1;

    _.forEach(db.fixture, function (match) {
      if (!result[match.homeTeam]) {
        result[match.homeTeam] = createTeam();
      }

      if (!result[match.awayTeam]) {
        result[match.awayTeam] = createTeam();
      }

      if (typeof match.homeTeamScore !== 'undefined') {
        result[match.homeTeam] = calculateStatistics(result[match.homeTeam], match.homeTeam, match.homeTeamScore, match.awayTeamScore);
        result[match.awayTeam] = calculateStatistics(result[match.awayTeam], match.awayTeam, match.awayTeamScore, match.homeTeamScore);
      }
    });

    _.forOwn(result, function (value, key) {
      positions.push(value);
    });

    positions = _.sortBy(positions, 'points');
    positions = positions.reverse();

    res.send({
      positions: _.map(positions, function (pos) {
        var temp = {
          position: position
        };
        position = position + 1;
        return _.merge(temp, pos);
      })
    });
  });

  function createTeam() {
    return {
      points: 0,
      matchesPlayed: 0,
      matchesWon: 0,
      matchesDraw: 0,
      matchesLost: 0,
      goalsInFavor: 0,
      goalsAgainst: 0
    };
  }

  function calculatePoints(homeTeamScore, awayTeamScore) {
    if (homeTeamScore > awayTeamScore) {
      return 3;
    } else if (homeTeamScore === awayTeamScore) {
      return 1;
    }

    return 0;
  }

  function calculateStatistics(team, teamName, homeTeamScore, awayTeamScore) {
    return {
      team: teamName,
      points: calculatePoints(homeTeamScore, awayTeamScore) + team.points,
      matchesPlayed: team.matchesPlayed + 1,
      matchesWon: homeTeamScore > awayTeamScore ? team.matchesWon + 1 : team.matchesWon,
      matchesDraw: homeTeamScore === awayTeamScore ? team.matchesDraw + 1 : team.matchesDraw,
      matchesLost: homeTeamScore < awayTeamScore ? team.matchesLost + 1 : team.matchesLost,
      goalsInFavor: homeTeamScore + team.goalsInFavor,
      goalsAgainst: awayTeamScore + team.goalsAgainst
    };
  }
};
