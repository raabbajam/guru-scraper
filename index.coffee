fs = require "fs"
path = require "path"
job = require "./services/job"
debug = require("debug")("raabbajam:scrape:tasker")
Promise = require "bluebird"
taskFile = path.join __dirname, "tasks.json"
tasks = JSON.parse(fs.readFileSync taskFile)
tasks = tasks.map (task) ->
  debug "inserting %s with data %j", task.name, task.data
  job.insert task.name, task.data
Promise.all tasks
  .then (data) ->
    debug "all task inserted"
    debug data
  .catch (err) ->
    debug err
# process.exit()
