express = require "express"
browserChannel = require("browserchannel").server
expressWinston = require "express-winston"
winston = require "winston"
routes = require "./routes"
passport = require "passport"
LocalStrategy = require("passport-local").Strategy
app = express()

logger = expressWinston.logger(
    transports:[
        new winston.transports.Console
            json:false
            colorize:true
    ]
)

#passport.use (new LocalStrategy (username, password, done) ->
    #console.log "authenticating #{username}"
    #done null, {username:username}
#)

app.configure ->
    app.set "view engine", "jade"
    app.use passport.initialize()
    app.use express.cookieParser()
    app.use express.session 
        secret: "segreto"
    app.use passport.session()
    #app.use express.router()
    app.use express.static(__dirname)
    app.use(logger)

sessions = []

app.get "/", routes.index
app.get "/login", routes.login
app.post "/auth/local", routes.auth.local
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


