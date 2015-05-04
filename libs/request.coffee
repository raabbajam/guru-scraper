Promise = require 'bluebird'
faker = require 'faker'
request = Promise.promisifyAll(require 'request')
defaults =
  jar: true
  headers:
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    "Accept-Encoding": "gzip, deflate, sdch"
    "Accept-Language": "en-US,en;q=0.8,ko;q=0.6,id;q=0.4,ms;q=0.2,fr;q=0.2"
    "Cache-Control": "no-cache"
    Connection: "keep-alive"
    Host: "www.pcrichard.com"
    Pragma: "no-cache"
    "User-Agent": faker.internet.userAgent()
    "X-FirePHP-Version": "0.0.6"
r = request.defaults(defaults)
module.exports = r
