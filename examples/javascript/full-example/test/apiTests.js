var should = require('should');
var request = require('supertest');
var app = require('../src/app');

var apiPath;

app.describe().then(function (app) {
  app.listen(3000);
  apiPath = 'http://localhost:3000/api';
});

describe('LEAGUES', function () {
  it('/teams should (200)', function(done) {
    request(apiPath)
      .get('/teams')
      .set('Accept', 'application/json')
      .end(function (err, res) {
        res.status.should.be.eql(200);
        done();
      });
  });
});
