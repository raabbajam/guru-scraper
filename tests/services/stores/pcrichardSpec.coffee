expect = require('chai').expect
storeService = require '../../../services/stores'
pcrichard = storeService 'pcrichard'

read = require('fs').readFileSync
path = require 'path'
cheerio = require 'cheerio'

describe 'pcrichard store api', ->
  @timeout 100000
  describe 'getCategories service', ->
    it 'should get all href', (done) ->
      options =
        url: 'Heating-and-Cooling/170.pcrc'
      # getCategories options
      pcrichard.get options
        .then((href) ->
          console.log href
          done()
        , done)
  describe 'getSubCategories service', ->
    it 'should get all href', (done) ->
      options =
        url: 'Heating-and-Cooling/Air-Conditioners/1010.pcrc'
      # getSubCategories options
      pcrichard.get options
        .then((href) ->
          console.log href
          done()
        , done)

  describe 'getProductList service', ->
    it 'should get all href', (done) ->
      options =
        url: 'Heating-and-Cooling/Air-Conditioners/Window-Air-Conditioners/101010.pcrc'
      # getProductList options
      pcrichard.get options
        .then((href) ->
          console.log href
          done()
        , done)

  describe 'getProductDetail service', ->
    it 'should request and parse', (done) ->
      options =
        url: 'Lasko/Lasko-18inch-Stand-Fan-White/1850W.pcrp?catId=101080'
      # getProductDetail options
      pcrichard.get options
        .then((json) ->
          console.log json
          done()
        , done)
