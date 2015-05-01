kue = require "../libs/kue"
Promise = require "bluebird"
_ = require "lodash"
insert = (taskName, taskData) ->
  new Promise (resolve, reject) ->
    if !_.isArray taskData
      taskData = [taskData]
    taskData = taskData.map (url) ->
      kue.addTask taskName, {url: url}
    Promise.all taskData

process = (task, concurrency, callback) ->
  kue.processTask task, concurrency, callback
listen = (port) ->
  kue.listen(port)
job =
  insert: insert
  process: process
  listen: listen

module.exports = job
