module.exports = (grunt) ->
    grunt.initConfig(
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
                files: ['coffee/*', 'less/*']
                tasks: ['build']
    )

    npmTasks = [
        "grunt-contrib-coffee"
        "grunt-contrib-less"
        "grunt-contrib-watch"
    ]

    (grunt.loadNpmTasks task for task in npmTasks)
    
    grunt.registerTask "build", ["coffee", "less"]
    grunt.registerTask "default", ["build", "server", "watch"]
    grunt.registerTask "server", "Runs the server", ->
        app = require "./server"
        app.listen(8081)

