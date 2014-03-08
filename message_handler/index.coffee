twitter = require 'twitter'
config = require '../config'

MessageHandler = class MessageHandler
    constructor: (dispatcher) ->
        dispatcher.on 'new_incoming_message', this.onNewMessage
        @twit = new twitter config.twitter_settings
        
    onNewMessage: (message) =>
        console.log 'new message event in message_handler', message.text

        regExp = /\bbot\s*retweet\s*(\d+)?\b/gi
        match = regExp.exec message.text
        if match
            this.retweetMessage match[1], message

    retweetMessage: (tweetid, message) ->
        options = 
                 in_reply_to_status_id: message.twitMsgId

        if !tweetid
            console.log 'updating status with options', options
            return @twit.updateStatus "@#{message.twitFromUserScreenName} retweet command is invalid, please provide the tweet id to be retweeted."
                            , options, (updateStatusData) =>
                console.log 'updateStatusData', updateStatusData
                console.error "invalid retweet request - no tweet id is available in message: ", message.text
                @signOffMessage message
            
        # console.log 'retweeting message', message
        @twit.post "/statuses/retweet/#{tweetid}.json", (err, result) =>
            if err
                return console.log 'received an ERROR!', err
            console.log "retweeted message, result: ", result
            @twit.updateStatus "@#{message.twitFromUserScreenName} retweeted message successfully", options, (updateStatusData) =>
                console.log 'send tweet reply ', updateStatusData
            @signOffMessage message

    signOffMessage: (message) ->
        message.replySent = true
        message.save()
        console.log 'saved and replied'

module.exports.MessageHandler = MessageHandler