fs = require "fs"
path = require "path"
job = require "./services/job"
debug = require("debug")("raabbajam:scrape:tasker")
taskFile = path.join __dirname, "tasks.json"
tasks = JSON.parse(fs.readFileSync taskFile)
tasks.forEach (task) ->
  debug "inserting %s with data %j", task.name, task.data
  job.insert task.name, task.data
  .then (data) ->
    debug data
  .catch (err) ->
    debug err
debug "all task inserted"
# process.exit()
