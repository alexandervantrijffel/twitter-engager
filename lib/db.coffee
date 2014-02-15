mongoose = require 'mongoose'
config = require '../config'
Schema = mongoose.Schema

module.exports.mongoose = mongoose
module.exports.Schema = Schema

console.log "connecting to database #{config.mongo.db} at uri #{config.mongo.host}\n"
mongoose.connect "mongodb://#{config.mongo.host}:#{config.mongo.port}/#{config.mongo.db}"

module.exports.disconnect = ->
  mongoose.disconnect
