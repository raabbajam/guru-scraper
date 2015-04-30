config = require '../docs/locals'
console.log 'config.redis.host', config.redis.host
client = require('redis').createClient(config.redis.port, config.redis.host, {})
module.exports = client;
