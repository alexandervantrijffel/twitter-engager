require "./config"
{TwitterListener} = require "./twitter_listener"
dispatcher = require "./lib/dispatcher"
{MessageHandler} = require "./message_handler"

listener = new TwitterListener()
messageHandler = new MessageHandler dispatcher

listener.on 'new_incoming_message', (message) ->
    dispatcher.send 'new_incoming_message', message

listener.emitTestEvent()
#messageHandler.onNewMessage {text: "@bot           bot retweet 1231237612736" }