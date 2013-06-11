express = require "express"
expressWinston = require "express-winston"
winston = require "winston"

app = express()

logger = expressWinston.logger(
    transports:[
        new winston.transports.Console
            json:false
            colorize:true
    ]
)

app.use logger

app.use express.static(__dirname)

module.exports = app

if require.main == module
    logger.info "Starting server on 8081"
    app.listen(8081)


