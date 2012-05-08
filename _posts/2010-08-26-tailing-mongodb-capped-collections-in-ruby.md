---
title: Tailing MongoDB Capped Collections in Ruby
layout: post
category: 
tags : 
---




This wasn't documented anywhere, so I figured others might find it
useful.&nbsp_place_holder;In MongoDB you can tail a capped collection, much
like using the tail -f command. This works because Mongo uses cursors.
Tailing's a nifty trick, especially if you're using Mongo for
logging.&nbsp_place_holder;

I'm using Phil Burrows mongo_db_logger to log all Rails reqs to a capped
collection at the moment, I'd recommend dropping this into your rails app,
after modifying it to read your mongo config so you always have it ready.

    
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    

#Kind of like tail -f -n1

db = Mongo::Connection.new(mongo_hostname).db(mongo_dbname)

coll = db.collection(mongo_collection)

start_count = coll.count

tail = Mongo::Cursor.new(coll, :tailable => true, :order => [['$natural',
1]]).skip(start_count- 1)

loop do

&nbsp_place_holder;&nbsp_place_holder;if doc = tail.next_document

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;pu
ts doc

&nbsp_place_holder;&nbsp_place_holder;else

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;sl
eep 1

&nbsp_place_holder;&nbsp_place_holder;end

end

