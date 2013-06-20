express = require "express"
browserChannel = require("browserchannel").server
expressWinston = require "express-winston"
winston = require "winston"
routes = require "./routes"
webCompiler = require('./server_modules/c-compile').webCompiler


app = express()
app.use(express.methodOverride())
wbc = new webCompiler(app)

logger = expressWinston.logger(
    transports:[
        new winston.transports.Console
            json:false
            colorize:true
    ]
)

app.set "view engine", "jade"
app.use express.static(__dirname)
app.use(logger)

sessions = []

app.get "/", routes.index
app.get "/login", routes.login

app.locals.pretty = true

broadcast = (sessions, message, exceptTo) ->
    for s in sessions
        if exceptTo.indexOf(s.id) == -1
            s.send message

app.use (browserChannel (session) ->
    console.log "New session: #{session.id} from #{session.address}"
    sessions.push session
    session.send(
        sender: "system"
        msg: "benvenuto"
    )
    broadcast sessions, {msg: "nuovo arrivato"}, [session.id]
    session.on "message", (data) ->
        console.log "#{session.id} sent #{JSON.stringify(data)}"

    session.on "close", (reason) ->
        console.log "#{session.id} disconnected because #{reason}"
)



module.exports = app

if require.main == module
    logger.info "Starting server on 8081"
    app.listen(8081)


