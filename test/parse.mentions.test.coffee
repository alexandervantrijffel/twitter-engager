{TwitterListener} = require("../twitter_listener/")
sinon = require "sinon"
IncomingMessage = require('../models/IncomingMessage').IncomingMessage
should = require  "should"
db = require "../lib/db"

describe 'twitter_listener', ->
  it 'should insert one unknown tweet to the database and emit a new_incoming_message event', (done) ->
    this.timeout(10000);

    listener = new TwitterListener()

    findIncomingMessagesStub = sinon.stub IncomingMessage, "findByTwitMsgIds"
    findIncomingMessagesStub.callsArgWith 1, undefined, dbData

    createMessageStub = sinon.stub IncomingMessage, "create"
    createMessageStub.callsArgWith 1, undefined, newItem

    listener.on 'new_incoming_message', (message) ->
        message.should.not.be.null
        message.twitMsgId.toString().should.be.equal newItem.twitMsgId.toString()
        done()

    listener.processMentions mentionsData
    findIncomingMessagesStub.calledOnce.should.be.true
    createMessageStub.calledOnce.should.be.true
    insertedMessage = createMessageStub.getCall(0).args[0]
    insertedMessage.twitMsgId.toString().should.be.equal newItem.twitMsgId.toString()
    insertedMessage.text.should.be.equal newItem.text
    insertedMessage.msgType.should.be.equal 'T'

newItem =
        twitMsgId: db.mongoose.Types.Long.fromString("427423107360772100")
        twitFromUserScreenName: "DotNetEventsNL"
        text: "The DotNetEvents Daily is out! http://t.co/uoSq4Cn4fN Stories via @MHoeijmans @avtnl @JoseCarballosa"
        msgType: "T"
        __v: 0
        replySent: false

dbData = [

    {
        twitMsgId: db.mongoose.Types.Long.fromNumber(433322180429225984)
        twitFromUserScreenName: "Ramonprick"
        text: "Aangemeld! RT @avtnl: Messaging, SOA, CQRS at Distributed Systems Design event in Rotterdam 27-2-2014. http://t.co/Pn3O5ysCqn @dvdstelt"
        msgType: "T"
        __v: 0
        replySent: false
    }
    {
        twitMsgId: db.mongoose.Types.Long.fromNumber(433324880499453952)
        twitFromUserScreenName: "Ramonprick"
        text: "@pjvds @avtnl leuk om weer even bij te praten!"
        msgType: "T"
        __v: 0
        replySent: false
    }
    {
        twitMsgId: db.mongoose.Types.Long.fromNumber(433525781193818112)
        twitFromUserScreenName: "pjvds"
        text: "@avtnl @ramonprick Bedankt voor het aanbod! Lijkt me leuk om weer bij te praten. Ik hoef alleen niet meer naar AMS: http://t.co/s1lPZbNsV9"
        msgType: "T"
        __v: 0
        replySent: false
    }
]
mentionsData = [
  {
    created_at: "Wed Feb 12 08:59:35 +0000 2014"
    id: 433525781193818100
    id_str: "433525781193818112"
    text: "@avtnl @ramonprick Bedankt voor het aanbod! Lijkt me leuk om weer bij te praten. Ik hoef alleen niet meer naar AMS: http://t.co/s1lPZbNsV9"
    source: "<a href=\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\" rel=\"nofollow\">Twitter for Mac</a>"
    truncated: false
    in_reply_to_status_id: 433521501430878200
    in_reply_to_status_id_str: "433521501430878208"
    in_reply_to_user_id: 245296197
    in_reply_to_user_id_str: "245296197"
    in_reply_to_screen_name: "avtnl"
    user:
      id: 16851081
      id_str: "16851081"
      name: "Pieter Joost"
      screen_name: "pjvds"
      location: "Netherlands, the"
      description: "@golang hacker | boardmember at Devnology | Microsoft C# MVP | Speaker Extravaganza | paleo | barefoot runner"
      url: "http://t.co/mvGFOKXeub"
      entities: [Object]
      protected: false
      followers_count: 1225
      friends_count: 479
      listed_count: 63
      created_at: "Sun Oct 19 13:36:17 +0000 2008"
      favourites_count: 1739
      utc_offset: 3600
      time_zone: "Amsterdam"
      geo_enabled: true
      verified: false
      statuses_count: 14651
      lang: "en"
      contributors_enabled: false
      is_translator: false
      is_translation_enabled: false
      profile_background_color: "C0DEED"
      profile_background_image_url: "http://abs.twimg.com/images/themes/theme1/bg.png"
      profile_background_image_url_https: "https://abs.twimg.com/images/themes/theme1/bg.png"
      profile_background_tile: false
      profile_image_url: "http://pbs.twimg.com/profile_images/1420109591/bbbbbbbbbbbbbbbbb_normal.jpg"
      profile_image_url_https: "https://pbs.twimg.com/profile_images/1420109591/bbbbbbbbbbbbbbbbb_normal.jpg"
      profile_link_color: "0084B4"
      profile_sidebar_border_color: "C0DEED"
      profile_sidebar_fill_color: "DDEEF6"
      profile_text_color: "333333"
      profile_use_background_image: true
      default_profile: true
      default_profile_image: false
      following: true
      follow_request_sent: false
      notifications: false

    geo: null
    coordinates: null
    place: null
    contributors: null
    retweet_count: 0
    favorite_count: 0
    favorited: false
    retweeted: false
    possibly_sensitive: false
    lang: "nl"
  }
  {
    created_at: "Tue Feb 11 19:41:16 +0000 2014"
    id: 433324880499453950
    id_str: "433324880499453952"
    text: "@pjvds @avtnl leuk om weer even bij te praten!"
    source: "<a href=\"http://www.echofon.com/\" rel=\"nofollow\">Echofon</a>"
    truncated: false
    in_reply_to_status_id: 433324135582679040
    in_reply_to_status_id_str: "433324135582679040"
    in_reply_to_user_id: 16851081
    in_reply_to_user_id_str: "16851081"
    in_reply_to_screen_name: "pjvds"
    user:
      id: 49317287
      id_str: "49317287"
      name: "Ramon Prick"
      screen_name: "Ramonprick"
      location: "Rotterdam area"
      description: "Freelance C# Software Developer, amateur photographer. E-mail: rprick@gmail.com"
      url: "http://t.co/hn09UVdguw"
      entities: [Object]
      protected: false
      followers_count: 115
      friends_count: 285
      listed_count: 3
      created_at: "Sun Jun 21 13:45:54 +0000 2009"
      favourites_count: 0
      utc_offset: 3600
      time_zone: "Amsterdam"
      geo_enabled: false
      verified: false
      statuses_count: 2444
      lang: "en"
      contributors_enabled: false
      is_translator: false
      is_translation_enabled: false
      profile_background_color: "19ABFF"
      profile_background_image_url: "http://pbs.twimg.com/profile_background_images/797507797/a8d29b7f372a6dae0fd663dcc2fb1fdc.jpeg"
      profile_background_image_url_https: "https://pbs.twimg.com/profile_background_images/797507797/a8d29b7f372a6dae0fd663dcc2fb1fdc.jpeg"
      profile_background_tile: false
      profile_image_url: "http://pbs.twimg.com/profile_images/2260016641/20120527_Profiel-2831_normal.jpg"
      profile_image_url_https: "https://pbs.twimg.com/profile_images/2260016641/20120527_Profiel-2831_normal.jpg"
      profile_banner_url: "https://pbs.twimg.com/profile_banners/49317287/1356632938"
      profile_link_color: "2B0AFF"
      profile_sidebar_border_color: "FFFFFF"
      profile_sidebar_fill_color: "DCDBFF"
      profile_text_color: "000000"
      profile_use_background_image: true
      default_profile: false
      default_profile_image: false
      following: true
      follow_request_sent: false
      notifications: false

    geo: null
    coordinates: null
    place: null
    contributors: null
    retweet_count: 0
    favorite_count: 0
    favorited: false
    retweeted: false
    lang: "nl"
  }
  {
    created_at: "Tue Feb 11 19:30:33 +0000 2014"
    id: 433322180429226000
    id_str: "433322180429225984"
    text: "Aangemeld! RT @avtnl: Messaging, SOA, CQRS at Distributed Systems Design event in Rotterdam 27-2-2014. http://t.co/Pn3O5ysCqn @dvdstelt"
    source: "<a href=\"http://www.echofon.com/\" rel=\"nofollow\">Echofon</a>"
    truncated: false
    in_reply_to_status_id: null
    in_reply_to_status_id_str: null
    in_reply_to_user_id: null
    in_reply_to_user_id_str: null
    in_reply_to_screen_name: null
    user:
      id: 49317287
      id_str: "49317287"
      name: "Ramon Prick"
      screen_name: "Ramonprick"
      location: "Rotterdam area"
      description: "Freelance C# Software Developer, amateur photographer. E-mail: rprick@gmail.com"
      url: "http://t.co/hn09UVdguw"
      entities: [Object]
      protected: false
      followers_count: 115
      friends_count: 285
      listed_count: 3
      created_at: "Sun Jun 21 13:45:54 +0000 2009"
      favourites_count: 0
      utc_offset: 3600
      time_zone: "Amsterdam"
      geo_enabled: false
      verified: false
      statuses_count: 2444
      lang: "en"
      contributors_enabled: false
      is_translator: false
      is_translation_enabled: false
      profile_background_color: "19ABFF"
      profile_background_image_url: "http://pbs.twimg.com/profile_background_images/797507797/a8d29b7f372a6dae0fd663dcc2fb1fdc.jpeg"
      profile_background_image_url_https: "https://pbs.twimg.com/profile_background_images/797507797/a8d29b7f372a6dae0fd663dcc2fb1fdc.jpeg"
      profile_background_tile: false
      profile_image_url: "http://pbs.twimg.com/profile_images/2260016641/20120527_Profiel-2831_normal.jpg"
      profile_image_url_https: "https://pbs.twimg.com/profile_images/2260016641/20120527_Profiel-2831_normal.jpg"
      profile_banner_url: "https://pbs.twimg.com/profile_banners/49317287/1356632938"
      profile_link_color: "2B0AFF"
      profile_sidebar_border_color: "FFFFFF"
      profile_sidebar_fill_color: "DCDBFF"
      profile_text_color: "000000"
      profile_use_background_image: true
      default_profile: false
      default_profile_image: false
      following: true
      follow_request_sent: false
      notifications: false

    geo: null
    coordinates: null
    place: null
    contributors: null
    retweet_count: 0
    favorite_count: 0
    favorited: false
    retweeted: false
    possibly_sensitive: false
    lang: "da"
  }
  {
    created_at: "Sun Jan 26 12:49:44 +0000 2014"
    id: 427423107360772100
    id_str: "427423107360772096"
    text: "The DotNetEvents Daily is out! http://t.co/uoSq4Cn4fN Stories via @MHoeijmans @avtnl @JoseCarballosa"
    source: "<a href=\"http://paper.li\" rel=\"nofollow\">Paper.li</a>"
    truncated: false
    in_reply_to_status_id: null
    in_reply_to_status_id_str: null
    in_reply_to_user_id: null
    in_reply_to_user_id_str: null
    in_reply_to_screen_name: null
    user:
      id: 230133717
      id_str: "230133717"
      name: "DotNetEvents"
      screen_name: "DotNetEventsNL"
      location: "Zoetermeer, Nederland"
      description: "Welkom bij @DotNetEventsNL, de site die je op de hoogte probeert te houden van alle bijeenkomsten voor de Nederlandse .NET ontwikkelaar."
      url: "http://t.co/xPiWNhzQCU"
      entities: [Object]
      protected: false
      followers_count: 610
      friends_count: 503
      listed_count: 26
      created_at: "Fri Dec 24 11:10:32 +0000 2010"
      favourites_count: 1
      utc_offset: 3600
      time_zone: "Amsterdam"
      geo_enabled: false
      verified: false
      statuses_count: 2838
      lang: "en"
      contributors_enabled: false
      is_translator: false
      is_translation_enabled: false
      profile_background_color: "C0DEED"
      profile_background_image_url: "http://abs.twimg.com/images/themes/theme1/bg.png"
      profile_background_image_url_https: "https://abs.twimg.com/images/themes/theme1/bg.png"
      profile_background_tile: false
      profile_image_url: "http://pbs.twimg.com/profile_images/1197798388/DotNetEvents_normal.PNG"
      profile_image_url_https: "https://pbs.twimg.com/profile_images/1197798388/DotNetEvents_normal.PNG"
      profile_link_color: "0084B4"
      profile_sidebar_border_color: "C0DEED"
      profile_sidebar_fill_color: "DDEEF6"
      profile_text_color: "333333"
      profile_use_background_image: true
      default_profile: true
      default_profile_image: false
      following: true
      follow_request_sent: false
      notifications: false

    geo: null
    coordinates: null
    place: null
    contributors: null
    retweet_count: 0
    favorite_count: 0
    favorited: false
    retweeted: false
    possibly_sensitive: false
    lang: "en"
  }
]