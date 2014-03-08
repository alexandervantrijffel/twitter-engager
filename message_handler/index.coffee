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
        if !tweetid
            # todo send error reply
            console.error "invalid retweet request - no tweet id is available in message: ", message.text
            return @signOffMessage message

        console.log 'retweeting message', message
        @twit.post "/statuses/retweet/#{tweetid}.json", (err, result) =>
            #.retweetStatus tweetid
            if err
                console.log 'received an ERROR!', err
            console.log "retweeted message,result: ", result
            # todo send reply
            signOffMessage message

    signOffMessage: (message) ->
        message.replySent = true
        message.save()
        console.log 'saved and replied'

module.exports.MessageHandler = MessageHandler