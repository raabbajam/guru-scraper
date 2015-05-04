store = (storeName) ->
  return require './modules/' + storeName
module.exports = store
