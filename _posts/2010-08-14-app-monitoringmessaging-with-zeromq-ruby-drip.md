---
title: App monitoring/messaging with ZeroMQ + Ruby = dripdrop
layout: post
category: 
tags : 
---




I just this week had an idea for realtime app stats/messaging using ZeroMQ. I
wanted to be able to view events from my app in real time, and be able to
archive them or do any random thing with them. Hence, dripdrop was born. It's
a pretty cool way of doing collecting stats or performing async tasks. There's
a full description of it on the GitHub project page at: [htt
p://github.com/andrewvc/dripdrop](http://github.com/andrewvc/dripdrop).

I'm mostly leveraging the awesome libraries that are zmq, zmqmachine, bert,
and em-websocket.

I've diagrammed my use case for it below:

![Dripdroptopology](./images/25754906-0-dripdroptopology.png.scaled.500.jpg)
