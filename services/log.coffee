winston = require "winston"
path = require "path"
filename = path.join __dirname, '..', 'docs', 'error.log'
winston.add(winston.transports.File, { filename: filename });
module.exports = winston.log
