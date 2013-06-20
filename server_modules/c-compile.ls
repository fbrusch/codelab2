express     = require 'express'
jQuery      = require 'jQuery'

require! "shelljs"
require! "moment"
require! "os"
require! "fs"


src = __dirname
otm = if (os.tmpdir?) then os.tmpdir() else "/var/tmp"
cwd = process.cwd()

setup-temporary-directory = ->
    name = "pb_#{moment().format('HHmmss')}_tmp"
    dire = "#{otm}/#{name}" 
    shelljs.mkdir '-p', dire
    return dire


clean-temporary-directory = (dir) ->
    shelljs.rm '-rf', dir
   
clean-all = ->
    shelljs.rm '-rf', "#{otm}/pb*"
    
dir = setup-temporary-directory()
    
console.log "C-Compiler - CWD: #cwd"
console.log "C-Compiler - TMP: #dir"
console.log "C-Compiler - SRC: #src"

# This should point to the local installation of emcc.. it is temporary at the moment
emcc-path = "emcc"
            

class web-compiler 

    (@app) ~>
            route = 'emscripten'
            console.log "C compiler running at '/#route' ", { +comp-server }
           
            @app.use(express.bodyParser())
            
            @app.post("/#route", (req, res) ~> 
                console.log req.body
                code = req.body.code
                try
                    (err) <~ fs.write-file("#dir/source.c", code)
                    code, output <~ shelljs.exec "#emcc-path #dir/source.c -o #dir/a.out.js"
                    if code != 0
                        throw "Error: #output"    
                    # cc = LiveScript.compile(code, null)
                    err, content <~ fs.read-file("#dir/a.out.js")
                    res.send((code: content.toString(), error: null))
                catch err
                    console.log "the type is: #{jQuery.type(err)}", { +comp-server }
                    console.log err.toString(), { +comp-server }
                    res.send({error: err.toString()})
                    )
            
            @app.get("/#route", (req, res) ~> res.send("OK"))


module.exports.web-compiler = web-compiler 