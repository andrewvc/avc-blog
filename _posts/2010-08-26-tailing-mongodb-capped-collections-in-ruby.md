---
permalink: tailing-mongodb-capped-collections-in-ruby
title: Tailing MongoDB Capped Collections in Ruby
layout: post
category: 
tags : [ruby, databases]
---




This wasn't documented anywhere, so I figured others might find it
useful. In MongoDB you can tail a capped collection, much
like using the tail -f command. This works because Mongo uses cursors.
Tailing's a nifty trick, especially if you're using Mongo for
logging. 

I'm using Phil Burrows mongo_db_logger to log all Rails reqs to a capped
collection at the moment, I'd recommend dropping this into your rails app,
after modifying it to read your mongo config so you always have it ready.

<script src="https://gist.github.com/550650.js?file=Tailing%20a%20MongoDB%20capped%20collection.rb"></script>
