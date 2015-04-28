scraper = require '../libs/scraper'
getCategories = (options) ->
  scraper.get$(options)
    .then(($) ->
      arr = []
      $('#content .cats li a').each((i, a) ->
        arr.push $(a).attr('href')
      )
      arr
    )
module.exports = getCategories
