
module.exports = (grunt) ->

  grunt.initConfig
    pkg:
      grunt.file.readJSON "package.json"
    clean:
      default:
        [
          "js"
          "css"
          "index.html"
        ]
      jade:
        "combined.jade"
    coffee:
      default:
        expand: true
        flatten: true
        cwd: "."
        src: "coffee/**/*.coffee"
        dest: "js"
        ext: ".js"
    concat:
      jade:
        src: [
          "jade/boilerplate/header.jade"
          "jade/index.jade"
        ]
        dest: "combined.jade"
      jsMin:
        src: [
          "bower_components/jquery/jquery.min.js"
          "js/breadcrumbs.min.js"
          "js/example.min.js"
        ]
        dest: "js/combined.min.js"
    jade:
      options:
        pretty: true
      default:
        files: "index.html":"combined.jade"
    less:
      breadcrumbs:
        files: "css/breadcrumbs.css":"less/breadcrumbs.less"
      breadcrumbsMin:
        options:
          yuicompress: true
        files: "css/breadcrumbs.min.css":"less/breadcrumbs.less"
      template:
        files: "css/template.css":"less/boilerplate/template.less"
      templateMin:
        options:
          yuicompress: true
        files: "css/template.min.css":"less/boilerplate/template.less"
      combinedMin:
        options:
          yuicompress: true
        files: "css/styles.min.css":[
          "less/boilerplate/template.less"
          "less/breadcrumbs.less"
        ]
    uglify:
      breadcrumbs:
        files: "js/breadcrumbs.min.js":"js/breadcrumbs.js"
      example:
        files: "js/example.min.js":"js/example.js"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"

  grunt.registerTask "default", "build"
  grunt.registerTask "build", [
    "clean"
    "concat:jade"
    "jade"
    "clean:jade"
    "coffee"
    "uglify:breadcrumbs"
    "uglify:example"
    "concat:jsMin"
    "less:breadcrumbs"
    "less:breadcrumbsMin"
    "less:template"
    "less:templateMin"
    "less:combinedMin"
  ]
