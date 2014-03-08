require 'coffee-script/register'
sinon = require "sinon"
{MessageHandler} = require "../message_handler"
should = require  "should"
db = require "../lib/db"

describe "MessageHandler", ->
    it "should execute bot command retweet tweet", (done) ->
        messageHandler = new MessageHandler( {on: sinon.stub()})
        postStub = sinon.stub(messageHandler.twit, "post");
        postStub.callsArgWith 1, undefined, "STUBBED!!!"
        updateStatusStub = sinon.stub(messageHandler.twit, "updateStatus");
        updateStatusStub.callsArgWith 2, "STUBBED mhm!"

        message = 
            text: "@bot           bot retweet 442306453920301056"
            save: sinon.stub()
            twitMsgId: 442306453920301056
            twitFromUserId: 1234689486
        messageHandler.onNewMessage message
        console.log 'twitpost', messageHandler.twit.post
        message.save.calledOnce.should.be.true
        done()

    it "should handle invalid bot command retweet tweet gracefully", (done) ->
        messageHandler = new MessageHandler( {on: sinon.stub()})
        updateStatusStub = sinon.stub(messageHandler.twit, "updateStatus");
        updateStatusStub.callsArgWith 2, "STUBBED mhm!"
        
        message = 
            text: "@bot bot   retweet   no id here"
            twitMsgId: 442306453920301056
            twitFromUserId: 1234689486
            save: sinon.stub()
        messageHandler.onNewMessage message
                        
        message.save.calledOnce.should.be.true
        message.replySent.should.be.true
        done()
