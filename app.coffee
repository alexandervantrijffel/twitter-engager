require "./config"
{TwitterListener} = require "./twitter_listener"

listener = new TwitterListener()
#listener.scheduleGetMentions()

listener.on 'new_incoming_message', (message) ->
    console.log 'we received a new message event', message
