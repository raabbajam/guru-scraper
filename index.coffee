fs = require "fs"
path = require "path"
job = require "./services/job"
debug = require "debug" "raabbajam:scrape:tasker"
taskFile = path.join __dirname, "tasks.json"
tasks = JSON.parse(fs.readFileSync taskFile)
tasks.forEach (task) ->
  debug "inserting %s with data %j", taskName, taskData
  job.insert taskName, taskData
