sinon = require "sinon"
{MessageHandler} = require "../message_handler"
should = require  "should"
db = require "../lib/db"

describe "MessageHandler", ->
    it "should execute bot command retweet tweet", (done) ->
        messageHandler = new MessageHandler( {on: sinon.stub()})
        messageHandler.onNewMessage { text: "@bot           bot retweet 1231237612736"}
        done()

    it "should handle invalid bot command retweet tweet gracefully", (done) ->
        messageHandler = new MessageHandler( {on: sinon.stub()})
        message = { text: "@bot bot   retweet   no id here", save: sinon.stub()}
        messageHandler.onNewMessage message
        message.save.calledOnce.should.be.true
        message.replySent.should.be.true
        done()
