getSubCategories = require '../../services/getSubCategories'
expect = require('chai').expect

describe.skip 'getSubCategories service', ->
  @timeout 100000
  it 'should get all href', (done) ->
    options =
      url: 'Heating-and-Cooling/Air-Conditioners/1010.pcrc'
    getSubCategories options
      .then((href) ->
        console.log href
        done()
      , done)
