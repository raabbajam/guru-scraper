Kue = require "kue"
config = require "../docs/locals"
Promise = require "bluebird"
queue = Kue.createQueue
  prefix: config.redis.prefix
  redis:
    port: config.redis.port
    host: config.redis.host
addTask = (task, data) ->
  new Promise (resolve, reject) ->
    job = queue.create task, data
    .backoff true
    .attempts 5
    .removeOnComplete true
    .save (err) ->
      if err
        return reject(err);
      job.on 'complete', (result) ->
        debug 'COMPLETE!!'
        return
      .on 'failed attempt', (err, times) ->
        debug('FAILED ATTEMPT!!! %d times, will try again', times, err)
        return reject err
      .on 'failed', (err) ->
        debug 'FAILED!!! max attempts reached, will not try again', times, err
        return reject err
      return resolve('saved');
    return
processTask = (task, concurrency, callback) ->
  queue.process task, concurrency, callback
listen = (port) ->
  Kue.app.listen(port)

process.once 'SIGTERM', (sig) ->
  queue.shutdown 5000, (err) ->
    debug 'Kue is shut down. ', err || ''
    process.exit( 0 )
process.once 'uncaughtException', (err) ->
  message = err.stack || err.message || err;
  debug 'uncaughtException\nKue is shut down. ', message
  queue.shutdown (err2) ->
    message2 = err.stack || err.message || err
    debug 'Kue is shut down. ', message2
    process.exit()
process.on 'message', (msg) ->
  if msg is 'shutdown'
    console.log 'Closing all connections...'
    queue.shutdown (err2) ->
      message2 = err.stack || err.message || err
      debug 'Kue is shut down. ', message2
      process.exit()
queue.on 'error', (err) ->
  debug 'Oops... ', err
.on 'job complete', (id, result) ->
  debug 'JOB COMPLETE!! id %s, %s', id, result
.on 'job failed attempt', (err, times) ->
  debug 'FAILED ATTEMPT!!! %d times, will try again', times, err
.on 'job failed', (err) ->
  debug 'FAILED!!! max attempts reached, will not try again', err
queue.active (err, ids) ->
  console.log "Active jobs, %j", ids
  ids.forEach (id) ->
    Kue.Job.get id, (err, job) ->
      if job
        job.inactive()
        console.log "Set job %s to inactive", id

kue =
  addTask: addTask
  processTask: processTask
  listen: listen
module.exports = kue
