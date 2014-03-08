db = require('../lib/db')
require('mongoose-long')(db.mongoose)

IncomingMessageSchema = new db.Schema
      twitMsgId: {type: db.mongoose.Types.Long, unique: true, required: true}
      twitFromUserId: {type: db.mongoose.Types.Long, required: true}
      twitFromUserScreenName: {type: String, required: true}
      text: {type: String, required: true}
      msgType: {type: String, required: true, uppercase: true, 'enum': ['T','DM'] }
      postedAt: {type: Date}
      processed: {type: Boolean, default: false}
      meta:
        updatedAt: { type: Date, 'default': Date.now }

IncomingMessageSchema.statics.findByTwitMsgId = (msgId, callback) ->
      this.db.model('IncomingMessage').findOne {twitMsgId: msgId}, callback

IncomingMessageSchema.statics.findByTwitMsgIds = (msgIds, callback) ->
    this.db.model('IncomingMessage').find {twitMsgId: { '$in': msgIds}}, callback

IncomingMessageSchema.statics.findLastMsg = (callback) ->
      this.db.model('IncomingMessage').findOne({}).sort('twitMsgId': -1).exec(callback)

IncomingMessageSchema.pre 'save', (next) ->
      this.meta.updatedAt = undefined
      next()

module.exports.IncomingMessage = db.mongoose.model 'IncomingMessage', IncomingMessageSchema
