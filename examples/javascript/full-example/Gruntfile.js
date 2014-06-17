var path = require('path');

module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: ['src/**/*.js']
    },

    express: {
      options: {
        port: process.env.PORT || 3000,
        script: 'src/app.js'
      },
      development: {
        options: {
          node_env: 'development'
        }
      },
      test: {
        options: {
          node_env: 'test',
          port: 3001
        }
      }
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
        },
        src: ['test/**/*.js']
      }
    },

    watch: {
      express: {
        files: ['src/**/*.js', 'src/assets/raml/**/*.*'],
        tasks: ['jshint', 'express:development'],
        options: {
          spawn: false,
          atBegin: true
        }
      }
    }
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('default', ['watch']);
  grunt.registerTask('test', ['mochaTest']);
};
