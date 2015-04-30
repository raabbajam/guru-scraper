kue = require "../libs/kue"
insert (taskName, taksData) ->
  kue.createTask taskName, taskData
process (task, concurrency, callback) ->
  kue.processTask task, concurrency, callback
listen (port) ->
  kue.listen(port)
job =
  insert: insert
  process: process
  listen: listen

module.exports = job
