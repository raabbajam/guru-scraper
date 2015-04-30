config = require '../docs/local'
console.log 'config.redis.host', config.redis.host
client = require('redis').createClient(config.redis.port, config.redis.host, {})
module.exports = client;
