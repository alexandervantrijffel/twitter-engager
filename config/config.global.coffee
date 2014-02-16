#default config settings for all environments

module.exports.env = 'development'

module.exports.twitter_settings =
  consumer_key: ''
  consumer_secret: ''
  access_token_key: ''
  access_token_secret: ''

module.exports.mongo = {}
module.exports.mongo.host = process.env.MONGO_HOST || 'localhost'
module.exports.mongo.db = 'twitter_engager'
module.exports.mongo.port = '27017'
module.exports.mongo.username = ''
module.exports.mongo.password = ''
