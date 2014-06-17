var fs    = require('fs');
var path  = require('path');

module.exports = function(api, db) {
  fs
  // read files in current directory
  .readdirSync(__dirname)

  // filter out index.js and non *.js files
  .filter(function (file) {
    return file !== 'index.js' && path.extname(file) === '.js';
  })

  // require every *.js file
  .map(function (file) {
    return require(path.join(__dirname, file))(api, db);
  });
};
