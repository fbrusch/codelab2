passport = require "passport"
LocalStrategy = require("passport-local").Strategy

passport.use (new LocalStrategy (username, password, done) ->
    console.log "authenticating #{username}"
    done(null, {username:username})
)

module.exports =

    index: (req, res) ->
        res.render "index"

    login: (req, res) ->
        #passport.authenticate "local", (req, res) ->
            #res.send "ciao #{req.user.username}"
        res.render "login"

    auth:
        local: passport.authenticate "local"

