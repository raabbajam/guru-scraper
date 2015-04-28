getCategories = require '../../services/getCategories'
expect = require('chai').expect

describe.skip 'getCategories service', ->
  @timeout 100000
  it 'should get all href', (done) ->
    options =
      url: 'Heating-and-Cooling/170.pcrc'
    getCategories options
      .then((href) ->
        console.log href
        done()
      , done)
