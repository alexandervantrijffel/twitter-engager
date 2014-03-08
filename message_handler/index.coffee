twitter = require 'twitter'
config = require '../config'
_ = require 'underscore'

MessageHandler = class MessageHandler
    constructor: (dispatcher) ->
        dispatcher.on 'new_incoming_message', this.onNewMessage
        @twit = new twitter config.twitter_settings
        
    onNewMessage: (message) =>
        try
            console.log 'new message event in message_handler', message.text

            match = /\bbot\s*retweet\s*(\d+)?\b/gi.exec message.text
            if match
                return this.retweetMessage match[1], message

            match = /\bbot\s*follow\s*@?\b([^\b]+)\b/gi.exec message.text
            if match
                return this.follow match[1], message
            else
                console.log 'message ignored: ' + message.text
        catch e
            console.error 'error encountered in MessageHandler.onNewMessage:', e

    retweetMessage: (tweetid, message) ->
        options = 
                 in_reply_to_status_id: message.twitMsgId.toString()

        if !tweetid
            # console.log 'updating status with options', options
            return @twit.updateStatus "@#{message.twitFromUserScreenName} retweet command is invalid, please provide the tweet id that must be retweeted."
                            , options, (updateStatusData) =>
                @logIfTwitFailed updateStatusData, "sending reply", message
                console.error "invalid retweet request - no tweet id is available in message: ", message.text
                @signOffMessage message
            
        # console.log 'retweeting message', message
        @twit.post "/statuses/retweet/#{tweetid}.json", (result) =>
            @throwIfTwitFailed result, "posting retweet"
            console.log "retweeted message, result: ", result
            @twit.updateStatus "@#{message.twitFromUserScreenName} retweeted message #{message.twitMsgId.toString()} successfully"
                    , options, (updateStatusData) =>
                @logIfTwitFailed updateStatusData, "sending reply", message
                console.log 'send tweet reply ', updateStatusData
                @signOffMessage message

    signOffMessage: (message) ->
        message.processed = true
        message.save()

    follow: (screenName, message) =>
        options = 
                 in_reply_to_status_id: message.twitMsgId.toString()
        @twit.createFriendship screenName, (result) =>
            @throwIfTwitFailed result, "creating friendship", message
            console.log "Friendship created with @#{screenName}"
            @twit.updateStatus "@#{message.twitFromUserScreenName} I am now following user #{screenName}"
                    , options, (updateStatusData) =>
                @logIfTwitFailed updateStatusData, "sending reply", message
                @signOffMessage message

    logIfTwitFailed: (result, action, message) ->
        if result && result.statusCode && result.statusCode != 200
            console.error "Received error #{result} with statusCode #{result.statusCode} while #{action}. Details: #{result.data}. Message: #{message}."

    throwIfTwitFailed: (result, action, message) ->
        if result && result.statusCode && result.statusCode != 200
            throw "Received error #{result} with statusCode #{result.statusCode} while #{action}. Details: #{result.data}. Message: #{message}."

module.exports.MessageHandler = MessageHandler