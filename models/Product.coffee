nohm = require('nohm').Nohm
debug = require('debug') 'raabbajam:models:product'
Promise = require 'bluebird'
redisClient = require './redisClient'
nohm.setClient redisClient
initialized = false;
productProperties =
  properties:
    url:
      type: 'string'
      index: true
      unique: true
      validations:
        [ 'notEmpty' ]
    data:
      type: 'json'
ProductModel = nohm.model 'Product', productProperties

all = ->
  new Promise (resolve, reject) ->
    ProductModel.find (err, ids) ->
      if err
        return reject err
      return resolve ids
get = (id, keep) ->
  debug 'getting %s', id
  new Promise (resolve, reject) ->
    product = nohm.factory 'Product', id, (err) ->
      if (err)
        return reject(new Error('skip me'))
      return resolve(product.p('data'))
###function check(name) {
  return new Promise(function(resolve, reject) {
    if (name === undefined) return reject(new Error('skip me'));
    user = nohm.factory('Product');
    user.p({
      name: name,
    });
    user.save(function (err) {
      if (err) {
        if (err === 'invalid') {
          debug('properties were invalid: %j, tryng to check possible empty..', user.errors);
          ProductModel.find({name: name}, function (err, ids) {
            if (err) return reject(err);
            debug(ids);
            id = ids[0] ? ids[0] : ids;
            get(id, true)
              .then(function (data) {
                if (!data) {
                  debug('no data: "%s", return this id..', data);
                  return resolve(id);
                }
                debug('have data %j, reject as duplicate', data);
                err = new Error('properties were invalid');
                err.errors = user.errors;
                return reject(err);
              })
              .catch(function (err) {
                return reject(new Error('skip me'));
              });
          });
        } else {
          debug(err); // database or unknown error
          return reject(new Error('skip me'));
        }
      } else {
        debug('Product not exist, created! :-)');
        // debug(user);
        return resolve(user.id);
      }
    });
  });
}
function init() {
  debug('Product init..');
  return new Promise(function(resolve, reject) {
    if (initialized) return resolve();
    initialized = true;
    redisClient.on('ready', function () {
      nohm.setClient(redisClient);
      return resolve();
    });
  });
}
function destroyAll() {
  debug('run destroy all!');
  return Product.all()
    .map(Product.destroy);
}
function destroy(id) {
  debug('tryng to delete user %s', id);
  return new Promise(function(resolve, reject) {
    user = nohm.factory('Product');
    user.id = id;
    user.remove(function (err) {
      if (err) return reject(err);
      debug('delete user %s', id);
      return resolve();
    });
  });
}
Product.all = all;
Product.get = get;
Product.check = check;
Product.destroy = destroy;
Product.destroyAll = destroyAll;
Product.init = init;###
insert = (data) ->
  new Promise (resolve, reject) ->
    product = nohm.factory 'Product'
    product.p data
    product.save (err) ->
      if err
        if err is 'invalid'
          debug 'properties were invalid: ', product.errors
          err = new Error 'properties were invalid'
          err.errors = product.errors
        else
          debug err; # database or unknown error
        return reject err
      debug 'Saved product!'
      return resolve()
init = ->
  debug 'Product init..'
  new Promise (resolve, reject) ->
    if (initialized)
      return resolve();
    initialized = true;
    redisClient.on 'ready', ->
      debug('Product initialized')
      nohm.setClient redisClient
      return resolve()

Product =
  insert: insert
  all: all
  get: get
  init: init
module.exports = Product;
