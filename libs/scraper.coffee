request = require './request'
Promise = require 'bluebird'
cheerio = require 'cheerio'

get$ = (options) ->
  options.url = 'http://www.pcrichard.com/' + options.url
  console.log options
  return new Promise((resolve, reject) ->
    request options, (err, res, body) ->
      if err
        return reject err
      console.log 'res.statusCode %d', res.statusCode
      try
        $ = cheerio.load body
      catch error
        return reject error
      return resolve $
  )
scraper =
  get$: get$
module.exports = scraper
