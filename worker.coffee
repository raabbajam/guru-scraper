debug = require "debug" "raabbajam:scrape:worker"
job = require "./services/job"
getCategories = require "./services/getCategories"
getSubCategories = require "./services/getSubCategories"
getProductList = require "./services/getProductList"
getProductDetail = require "./services/getProductDetail"
Product = require "./models/Product"

concurrency = 3

job.process "getCategories", concurrency, (job, done) ->
  debug "starting getCategories for url %s", job.data.url
  options =
    url: job.data.url
  getCategories options
    .then((urls) ->
      debug "getCategories finished, got urls from url %s: %j", job.data.url, urls
      urls.forEach (url) ->
        data =
          url: url
        job.insert "getSubCategories", data

job.process "getSubCategories", concurrency, (job, done) ->
  debug "starting getSubCategories for url %s", job.data.url
  options =
    url: job.data.url
  getSubCategories options
    .then((urls) ->
      debug "getSubCategories finished, got urls from url %s: %j", job.data.url, urls
      urls.forEach (url) ->
        data =
          url: url
        job.insert "getProductList", data

job.process "getProductList", concurrency, (job, done) ->
  debug "starting getProductList for url %s", job.data.url
  options =
    url: job.data.url
  getProductList options
    .then((urls) ->
      debug "getProductList finished, got urls from url %s: %j", job.data.url, urls
      urls.forEach (url) ->
        data =
          url: url
        job.insert "getProductDetail", data

job.process "getProductDetail", concurrency, (job, done) ->
  debug "starting getProductDetail for url %s", job.data.url
  options =
    url: job.data.url
  getProductDetail options
    .then((data) ->
      debug "getProductDetail finished, got data from url %s: %j", job.data.url, data
      product:
        url: job.data.url
        data: data
      Product.insert(product)
