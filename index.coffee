fs = require "fs"
path = require "path"
job = require "./services/job"
debug = require("debug")("raabbajam:scrape:tasker")
Promise = require "bluebird"
taskFile = path.join __dirname, "tasks.json"

tasklist = JSON.parse(fs.readFileSync taskFile)
tasklist = tasklist.map (tasks) ->
  tasks.urls.forEach (url) ->
    debug "inserting %s with data %j", tasks.name, url
  job.insert tasks.name, tasks.urls
Promise.all tasklist
  .then (data) ->
    debug "all task inserted"
    debug data
    process.exit()
  .catch (err) ->
    debug err
