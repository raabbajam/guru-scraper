Kue = require "kue"
config = require "../docs/local"
Promise = require "bluebird"
queue = Kue.createQueue
  prefix: config.redis.prefix
  redis:
    port: config.redis.port
    host: config.redis.host

addTask (task, data) ->
  new Promise((resolve, reject) ->
    job = queue.create(task, data)
    .backoff(true)
    .attempts(5)
    .removeOnComplete( true )
    .save((err) ->
      if (err)
        return reject(err);
      return resolve();
    )
    job.on('complete', (result) ->
      debug('COMPLETE!!')
      return
    ).on('failed attempt', (err, times) ->
      debug('FAILED ATTEMPT!!! %d times, will try again', times, err)
      return reject(err)
    ).on('failed', (err) ->
      debug('FAILED!!! max attempts reached, will not try again', times, err)
      return reject(err)
    )
  )
processTask (task, concurrency, callback) ->
  queue.process task, concurrency, callback
listen (port) ->
  Kue.app.listen(port)

kue =
  addTask: addTask
  processTask: processTask
  listen: listen
module.exports = kue
