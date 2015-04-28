scraper = require '../libs/scraper'
parseNum = (text) ->
  +text.replace(/[^\.0-9]/g, '')
parseDetail = ($) ->
  modelNumber = $('.pdp-sku').text().trim().replace /Model:\s/, ''
  url = $('link[rel=canonical]').attr 'href'
  urlPart = url.split '/'
  # data = $('.wc-fragment').data()
  productLabel = urlPart[3]
  brandName = urlPart[4].replace(/-/g, ' ')
  shortFeature = [].slice.call($('.pdp-intro li').map((i, li) ->
      $(li).text()
    )).join('\n')
  longFeature = [].slice.call($('.wc-rich-features h3, .wc-rich-features .wc-rich-content-description').map((i, el) ->
      $el = $(el)
      txt = $el.text()
      if $el[0].name is "h3"
        txt = '-' + txt
      txt
    )).join('\n')
  shortDesc = [productLabel, modelNumber, shortFeature].join '\n'
  longDesc = [productLabel, modelNumber, longFeature].join '\n'
  breadcrumb = $('#breadcrumb p a')
  categoryId = +breadcrumb.eq(1).attr('href').match(/(\d+).pcrc/)[1]
  type = breadcrumb.last().text()
  site: 'pcrichard'
  store_id: 0
  item_number: 0
  model_number: modelNumber
  store_sku_number: modelNumber
  upc: 'How to get this?'
  item_type: type
  availability_type: 'How to get this?'
  web_url: url
  canonical_url: url
  short_desc: shortDesc
  long_desc: longDesc
  brand_name: brandName
  product_label: productLabel
  vendor_number: 'How to get this?'
  source: 'scrape'
  primary_category_id: categoryId
  average_rating: parseNum($('.pr-review-count').text())
  total_reviews: parseNum($('.pr-snippet-rating-decimal.pr-rounded').text())
  original_price: parseNum($('.pdp-price ins').text())
  special_price: 'How to get this?'
  inventory_storeid: 'How to get this?'
  inventory_on_hand: 'How to get this?'
  inventory_expected_available: 'How to get this?'
  inventory_location: 'How to get this?'
  m1: 'How to get this?'
  m1_units: 'How to get this?'
  m2: 'How to get this?'
  m2_units: 'How to get this?'
  sem3_scrape_date: 'TODO check format'
  info_source: 'How to get this?'
  vendor_name: 'How to get this?'
  is_scraped: true
  date_created: ''
  date_updated: ''
getProductList = (options) ->
  scraper.get$(options)
    .then(parseDetail)
module.exports = getProductList
