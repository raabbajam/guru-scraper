Promise = require 'bluebird'
request = Promise.promisifyAll(require 'request')

module.export = request
