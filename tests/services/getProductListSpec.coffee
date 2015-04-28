getProductList = require '../../services/getProductList'
expect = require('chai').expect

describe.skip 'getProductList service', ->
  @timeout 100000
  it 'should get all href', (done) ->
    options =
      url: 'Heating-and-Cooling/Air-Conditioners/Window-Air-Conditioners/101010.pcrc'
    getProductList options
      .then((href) ->
        console.log href
        done()
      , done)
