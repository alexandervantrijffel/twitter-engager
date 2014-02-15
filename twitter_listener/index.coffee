{EventEmitter} = require 'events'
twitter = require 'twitter'
config = require '../config'
db = require('../lib/db')
IncomingMessage = (require '../models/IncomingMessage').IncomingMessage
_ = require 'underscore'

TIMESPAN_MINUTE=60000

class TwitterListener extends EventEmitter
    constructor: ->
        if (config)
            @twit = new twitter config.twitter_settings
            @sinceId = IncomingMessage.findLastMsg (err, data) =>
                if !err && data
                    @sinceId = parseFloat(data.twitMsgId.toString())
                    console.log "setting sinceId to",@sinceId
                    #@scheduleGetMentions()

    emitTestEvent: =>
        IncomingMessage.findByTwitMsgId 433324880499453952, (err, dbItem) =>
            @emit 'new_incoming_message', dbItem

    scheduleGetMentions: =>
        options = {include_entities:false, count: 25}
        options.since_id = @sinceId if @sinceId
        console.log "timeline options",options
        @twit.get '/statuses/mentions_timeline.json', options, (data) =>
            @processMentions(data)
        setTimeout @scheduleGetMentions, 10000 # 5 * TIMESPAN_MINUTE

    processMentions: (data) =>
        if data.statusCode && data.statusCode != 200
            return console.log "Received error #{data} from Twitter. Details: #{data.data}"

        if !data || data.length == 0
            return console.log "No mentions found"

        #console.log "received data from twitter ", data
        msgIds = _.map data, (item) -> item.id
        maxId = _.max msgIds
        if maxId > @sinceId
            console.log "setting since Id to",@sinceId
            @sinceId = maxId

        IncomingMessage.findByTwitMsgIds msgIds, (err,messagesFromDb) =>
            throw err if err
            console.log "found #{messagesFromDb && messagesFromDb.length || 0} items in the database out of #{data.length} Twitter mentions"
            newMessages = data

            # filter messages that have been processed before
            if messagesFromDb
                newMessages = _.filter data, (twitterItem) ->
                    dbItemFound = _.find messagesFromDb, (dbItem) -> dbItem.twitMsgId.equals(db.mongoose.Types.Long.fromNumber(twitterItem.id))
                    return dbItemFound == undefined

            # insert into the database and emit events
            _.each newMessages, (item) =>
                console.log "adding tweet #{item.id} to the database"
                IncomingMessage.create
                      twitMsgId: item.id
                      twitFromUserId: item.user.id
                      twitFromUserScreenName: item.user.screen_name
                      text: item.text
                      msgType: 'T'
                      postedAt: item.created_at
                      , (err, theMessage) =>
                          throw err if err
                          console.log "incomingmessage added to db #{theMessage.twitMsgId} - #{theMessage.text}.\nPublishing new_incoming_message event"
                          @emit 'new_incoming_message', theMessage

# bot follow @user
        # bot retweet 1233242345873495
        # bot
module.exports.TwitterListener = TwitterListener