Product = require './models/Product'
Promise = require 'bluebird'
_ = require 'lodash'
fs = Promise.promisifyAll(require 'fs')
jsoncsv = require 'json-csv'
path = require 'path'
debug = require('debug')('raabbajam:formatter')
concurrent = 100;

getFields = ->
  [
    { name : 'name', label : 'Developer name' },
    {name: 'site', label: 'site'}
    {name: 'store_id', label: 'store_id'}
    {name: 'item_number', label: 'item_number'}
    {name: 'model_number', label: 'model_number'}
    {name: 'store_sku_number', label: 'store_sku_number'}
    {name: 'upc', label: 'upc'}
    {name: 'item_type', label: 'item_type'}
    {name: 'availability_type', label: 'availability_type'}
    {name: 'web_url', label: 'web_url'}
    {name: 'canonical_url', label: 'canonical_url'}
    {name: 'short_desc', label: 'short_desc'}
    {name: 'long_desc', label: 'long_desc'}
    {name: 'brand_name', label: 'brand_name'}
    {name: 'product_label', label: 'product_label'}
    {name: 'vendor_number', label: 'vendor_number'}
    {name: 'source', label: 'source'}
    {name: 'primary_category_id', label: 'primary_category_id'}
    {name: 'average_rating', label: 'average_rating'}
    {name: 'total_reviews', label: 'total_reviews'}
    {name: 'original_price', label: 'original_price'}
    {name: 'special_price', label: 'special_price'}
    {name: 'inventory_storeid', label: 'inventory_storeid'}
    {name: 'inventory_on_hand', label: 'inventory_on_hand'}
    {name: 'inventory_expected_available', label: 'inventory_expected_available'}
    {name: 'inventory_location', label: 'inventory_location'}
    {name: 'm1', label: 'm1'}
    {name: 'm1_units', label: 'm1_units'}
    {name: 'm2', label: 'm2'}
    {name: 'm2_units', label: 'm2_units'}
    {name: 'sem3_scrape_date', label: 'sem3_scrape_date'}
    {name: 'info_source', label: 'info_source'}
    {name: 'vendor_name', label: 'vendor_name'}
    {name: 'is_scraped', label: 'is_scraped'}
    {name: 'date_created', label: 'date_created'}
    {name: 'date_updated', label: 'date_updated'}
  ]

writeJSON = (json) ->
  filename = path.join __dirname, 'docs', 'output.json'
  return fs.writeFileAsync filename, JSON.stringify json, null, 2

toCSV = (aoJSON) ->
  new Promise (resolve, reject) ->
    callback = (err, csv) ->
      if err
        return reject err
      return resolve csv
    options =
      fields: getFields()
    jsoncsv.csvBuffered aoJSON, options, callback

writeCSV = (csv) ->
  filename = path.join __dirname, 'docs', 'output.csv'
  return fs.writeFileAsync filename, csv

format = () ->
  debug 'format'
  return Product.init()
    .then Product.all
    .then (products) ->
      proms = products.map (product) ->
        return  Product.get product
      opts =
        concurrent: concurrent
      Promise.settle proms, opts
        .then (values) ->
          values.filter (res) ->
            return res.isFulfilled()
          .map (res) ->
            res.value()
    .then (json) ->
      writeJSON(json)
      return json
    .then toCSV
    .then writeCSV

format()
  .then ->
    debug 'Finished. Bye~'
    process.exit(0)
  .catch (err) ->
    debug(err);
    process.exit(0)
