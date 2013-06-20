express     = require 'express'
jQuery      = require 'jQuery'

require! "shelljs"
require! "moment"
require! "os"
require! "fs"


web-compiler = require('./c-compile').web-compiler


class web-compiler-test 

    (@port) ~>
        @app = express()
        @app.use(express.method-override())
        @server = require('http').createServer(@app)
        
    serve: ~>
        @server.listen(@port) 
        console.log "Listening on port: #{@port}"

wbt = new web-compiler-test(4444)
wbc = new web-compiler(wbt.app)
wbt.serve()         
