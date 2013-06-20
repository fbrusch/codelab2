module.exports = (grunt) ->
    grunt.initConfig(
        coffee:
            default:
                src: 'coffee/*.coffee'
                dest: 'index.js'
                
        livescript:
            default:
                compile:
                    files:
                        {
                            'server_modules/c_compile.js': ['server_modules/c_compile.ls']
                        }
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
        'grunt-livescript';
    ]

    (grunt.loadNpmTasks task for task in npmTasks)
    
    grunt.registerTask "build", ["coffee", "livescript", "less"]
    grunt.registerTask "default", ["build", "server", "watch"]
    grunt.registerTask "server", "Runs the server", ->
        app = require "./server"
        app.listen(8081)

