Product = require './models/Product'
Promise = require 'bluebird'
_ = require 'lodash'
fs = Promise.promisifyAll(require 'fs')
jsoncsv = require 'json-csv'
path = require 'path'
debug = require('debug')('raabbajam:formatter')
concurrent = 100;
format = () ->
  debug 'format'
  return Product.init()
    .then Product.all
    .then (products) ->
      proms = products.map((product) ->
        return  Product.get product
      opts =
        concurrent: concurrent
      Promise.settle proms, opts
        .then (values) ->
          values.filter (res) ->
            return res.isFulfilled()
          .map (res) ->
            res.value()
    .then toCSV
    .then write

toCSV = (aoJSON) ->
  #debug('aoJSON', aoJSON[0]);
  new Promise (resolve, reject) ->
    options =
      fields: getFields()
    jsoncsv.csvBuffered aoJSON, options, callback
    callback = (err, csv) ->
      if err
        return reject err
      return resolve csv

write = (csv) ->
  filename = path.join __dirname, 'output.csv'
  return fs.writeFileAsync filename, csv

getFields = ->
  [
    { name : 'name', label : 'Developer name' },
    { name : 'email', label : 'Developer email address' },
    { name : 'joinDate', label : 'Join Date' },
    { name : 'web', label : 'Web page' },
    { name : 'id', label : 'developer id' },
    { name : 'country', label : 'Country' },
    { name : 'contributionYear', label : 'Contributions this year' },
    { name : 'overallContributions', label : 'Contributions over all' },
    { name : 'contributionMonth', label : 'Contributions last month' },
    { name : 'pullRequestMonth', label : 'Pull requests last month' },
    { name : 'longestStreak', label : 'Longest streak' },
    { name : 'currentStreak', label : 'Current streak' },
    { name : 'repositoriesContributed', label : 'Number of repositories contributed to' },
    { name : 'followers', label : 'Followers' },
    { name : 'following', label : 'Stars' },
    { name : 'starred', label : 'Following' },
    { name : 'repoName', label : 'Name of repository' },
    { name : 'description', label : 'Description' },
    { name : 'startDate', label : 'Start date' },
    { name : 'contributors', label : 'Number of contributors to repository' },
    { name : 'commits', label : 'Number of commits  to repository' },
    { name : 'commitLastMonth', label : 'Number of commits in last month  to repository' },
    { name : 'branches', label : 'Number of branches  to repository' },
    { name : 'releases', label : 'Number of releases  to repository' },
    { name : 'userCommitLastMonth', label : 'Number of contributions from the developer in the last month' },
    { name : 'userCommitOverall', label : 'Number of contributions from the developer overall' },
  ]

format()
  .then ->
    debug 'Finished. Bye~'
    process.exit(0)
  .catch (err) ->
    debug(err);
    process.exit(0)
