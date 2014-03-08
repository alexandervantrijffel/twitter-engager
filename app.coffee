require 'coffee-script/register'
require "./config"
iced = require('iced-coffee-script').iced;

{TwitterListener} = require "./twitter_listener"
dispatcher = require "./lib/dispatcher"
{MessageHandler} = require "./message_handler"

listener = new TwitterListener()
messageHandler = new MessageHandler dispatcher

listener.on 'new_incoming_message', (message) ->
    dispatcher.send 'new_incoming_message', message

#listener.emitTestEvent()