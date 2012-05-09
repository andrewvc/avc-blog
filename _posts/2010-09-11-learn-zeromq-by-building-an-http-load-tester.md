---
permalink: learn-zeromq-by-building-an-http-load-tester
title: Learn ZeroMQ by Building an HTTP Load Tester
layout: post
tags : [ruby]
---




I've just added a new, fully functional, example to my "Learn Ruby Zeromq"
project: an [HTTP load tester](http://github.com/andrewvc/learn-ruby-
zeromq/blob/master/002_Example_Programs/http_load.rb), in the vein of tools
like the venerable `ab` from apache.

By leveraging ZeroMQ, we have a tool that's easily scalable across multiple
machines, all reporting back to a control server. Check out
[http_load.rb](http://github.com/andrewvc/learn-ruby-
zeromq/blob/master/002_Example_Programs/http_load.rb) on github to see it in
action.

It's short at about 180 lines (including whitespace!), and contains a
reasonable amount of error handling code, so it's not so simple as to be
practically useless.

For more examples, (including beginners ones, if this one has left you a
little lost), check out [Learn Ruby ZeroMQ](http://github.com/andrewvc/learn-
ruby-zeromq) on github.

