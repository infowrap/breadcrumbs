
module.exports = (grunt) ->

  grunt.initConfig
    pkg:
      grunt.file.readJSON "package.json"
    clean:
      default:
        ["js", "css", "index.html"]
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
        src: ["jade/boilerplate/header.jade", "jade/index.jade"]
        dest: "combined.jade"
    jade:
      options:
        pretty: true
      default:
        files: "index.html":"combined.jade"
    less:
      default:
        files: "css/styles.css":"less/styles.less"
      production:
        options:
          paths: ["assets/css"]
          yuicompress: true
        files: "css/styles.min.css":"less/styles.less"
    uglify:
      default:
        files: "js/breadcrumbs.min.js":"js/breadcrumbs.js"
    watch:
      options:
        events: ["changed", "added"]
        spawn: true
      default:
        files: ["coffee/**/*.coffee", "less/**/*.less"]
        tasks: ["default"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-docular"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"

  grunt.registerTask "default", "build"
  grunt.registerTask "build", ["clean", "concat:jade", "jade", "clean:jade", "coffee", "uglify", "less", "less:production"]
  grunt.registerTask "dev", ["default", "watch"]
