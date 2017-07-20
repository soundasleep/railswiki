module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      js: ['public/js/**/*.js']

    coffee:
      dist:
        files: [{
          expand: true
          cwd: 'public/javascripts'
          src: ['**/*.coffee']
          dest: 'public/js/build'
          ext: '.js'
        }]

    browserify:
      options:
        transform: ['babelify']
      dist:
        src: 'public/js/build/**/*.js'
        dest: 'public/js/compiled.js'

    watch:
      scripts:
        files: ['public/**/*.coffee']
        tasks: ['coffee', 'browserify']

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', "Generate static sites and assets", [
    'clean',
    'coffee',
    'browserify'
  ]
  grunt.registerTask 'build', ['default']

  grunt.registerTask 'serve', [
    'default',
    'watch'
  ]
  grunt.registerTask 's', ['serve']
