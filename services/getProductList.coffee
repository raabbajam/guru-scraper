scraper = require '../libs/scraper'
getProductList = (options) ->
  options.url += '?pageNum=0&trail=&pageSize=60'
  scraper.get$(options)
    .then(($) ->
      arr = []
      $('.item-title a').each((i, a) ->
        arr.push $(a).attr('href')
      )
      arr
    )
module.exports = getProductList
