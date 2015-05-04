debug = require("debug")("raabbajam:scrape:worker")
Product = require "./models/Product"
Job = require "./services/job"
Store = require "./services/stores"
log = require "./services/log"
_ = require "lodash"
pcrichard = Store 'pcrichard'
concurrency = 1

Product.init()
  .then ->
    debug 'Listen to jobs'

    Job.process "pcrichard", concurrency, (job, done) ->
      debug "starting scrape for pcrichard url %s", job.data.url
      pcrichard.get job.data
        .then (output) ->
          if _.isArray output
            debug "scraper for pcrichard finished, got urls from url %s: %j", job.data.url, output
            return Job.insert("pcrichard", output)
          else
            debug "scraper for pcrichard finished, got product from url %s: %j", job.data.url, output
            return Product.insert({
              url: job.data.url,
              data: output,
            })
        .then ->
          debug "Job done"
          done()
        .catch (err) ->
          debug err.stack
          log err
          done err
