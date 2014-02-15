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
            retweetMessage message


        #   regExp = /\s*@?([a-zA-Z\d]+)\s+/g
        #   match = regExp.exec message.text
        #   while (match != null)
        #       console.log "match '#{match[0]}'    start #{match.index} group 1 '#{match[1]}'"
        #       match = regExp.exec message.text

    retweetMessage: (message) ->
        if !match[1]
            # todo send error reply
            console.error "invalid retweet request - no tweet id is available in message: ", message.text
            return @signOffMessage message

        # todo uitzoeken waarom dit niet in test werkt (alleen bij runnen van de app)
        @twit.post "/statuses/retweet/#{match[1]}.json", (result) =>
            #.retweetStatus match[1]
            console.log "retweeted message,result: ", result
            # todo send reply
            signOffMessage message

    signOffMessage: (message) ->
        message.replySent = true
        message.save()

module.exports.MessageHandler = MessageHandler