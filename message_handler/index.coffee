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
        console.log 'tweetid', tweetid
        if !tweetid
            # todo send error reply
            console.error "invalid retweet request - no tweet id is available in message: ", message.text
            return @signOffMessage message

        @twit.post "/statuses/retweet/#{tweetid}.json", (result) =>
            #.retweetStatus match[1]
            console.log "retweeted message,result: ", result
            # todo send reply
            signOffMessage message

    signOffMessage: (message) ->
        message.replySent = true
        message.save()
        console.log 'saved and replied'

module.exports.MessageHandler = MessageHandler