module.exports = (grunt) ->
    grunt.initConfig(
        jade:
            default:
                src: 'jade/*.jade'
                dest: 'index.html'
                pretty: yes
        coffee:
            default:
                src: 'coffee/*.coffee'
                dest: 'index.js'
        less:
            default:
                src: 'less/*.less'
                dest: 'style.css'
        watch:
            rebuild:
                files: ['jade/*', 'coffee/*', 'less/*']
                tasks: ['build']
    )

    npmTasks = [
        "grunt-contrib-jade"
        "grunt-contrib-coffee"
        "grunt-contrib-less"
        "grunt-contrib-watch"
    ]

    (grunt.loadNpmTasks task for task in npmTasks)
    
    grunt.registerTask "build", ["jade", "coffee", "less"]
    grunt.registerTask "default", ["build"]

