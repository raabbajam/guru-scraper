rewire = require 'rewire'
read = require('fs').readFileSync
path = require 'path'
cheerio = require 'cheerio'
filename = path.join(__dirname, 'html', 'detail.html')
getProductDetail = rewire '../../services/getProductDetail'
expect = require('chai').expect

describe 'getProductDetail service', ->
  @timeout 100000
  it.skip 'should parse html', (done) ->
    text = read filename
    $ = cheerio.load text
    json = getProductDetail.__get__('parseDetail') $
    console.log json
    done()
  it 'should request and parse', (done) ->
    options =
      url: 'Lasko/Lasko-18inch-Stand-Fan-White/1850W.pcrp?catId=101080'
    getProductDetail options
      .then((json) ->
        console.log json
        done()
      , done)
