---
title: "Next Step for DripDrop: ZeroMQ Distributed Workers"
layout: post
category: 
tags : 
---




I've been thinking about [DripDrop](http://github.com/andrewvc/dripdrop)'s
design goals lately. One of the core goals of DripDrop is to make writing
highly concurrent apps that run on both single
and multiple machines as easy as possible.
The idea is that anywhere there's a ZeroMQ socket, you can just break that
part of the app off and run it over your network (so long as latency won't be
prohibitive). This composability isn't something that DripDrop provides, that
fully comes from the magic of ZeroMQ and BERT. The role of DripDrop is simply
to make using those sockets so easy that you'll use them before you even need
them (at the cost of low level control and performance in some situations).

As it _currently_ stands, DripDrop is a
framework for making message based apps easier to build in a reactor pattern
by leveraging ZeroMQ. Since DripDrop is built on top of
[ZMQMachine](http://github.com/chuckremes/zmqmachine) and
[EventMachine](http://www.igvita.com/2008/05/27/ruby-eventmachine-the-speed-
demon/), DripDrop apps inherit all the strengths and weaknesses of the reactor
pattern. Really, DripDrop is just a thin wrapper around these libraries,
normalizing and simplifying the API to deal exclusively with its message
format. This lets us semi-seamlessly stich together HTTP, WebSockets, and
ZeroMQ sockets in very few lines of code. However, Reactors are not the be-all
end-all of concurrency design.

While reactors are useful for expressing some problems, often times a thread
pool fits the problem better. EventMachine actually handles this reasonably
well with EM.defer, which simply hands over a block of code to be executed in
a thread pool. I'd like to add a worker pool to DripDrop than can be broken
out to run over any number of machines on your network, and I'd like to make
this as easy to use as EM.defer.

This should be dead simple, but foresee some possible pitfalls. ZeroMQ sockets
do [apply
backpressure](http://comments.gmane.org/gmane.network.zeromq.devel/4041),
which is useful in a situation like this, but I'll have to see for myself how
well it works for this scenario (as they say, trust but verify). My initial
plan is to build a new version of the [ZeroMQ HTTP Load
Tester](http://github.com/andrewvc/learn-ruby-
zeromq/blob/master/002_Example_Programs/http_load.rb) with
this extension to DripDrop, to give it some basis in
reality. 

Additionally, I've had thoughts of monitoring the state of all the sockets in
a DripDrop app. I'm probably going to add a control backchannel to DripDrop
sockets that'll give application writers a high level view of traffic on their
DripDrop apps, perhaps reporting back to a Sub socket that keeps counters in
Redis. 

Additionally, it'd be nice to know when distributed processes go down, so a
long term goal would be to implement a set of deployment scripts that only
start up certain services based on role, and establishing a central control
server that monitors this backchannel for problems.

If anyone finds these goals useful (or not) let me know. Sadly, I only have so
much free time, so they may be a while in coming... If anyone out there thinks
these would be interesting things to work on, shoot me a line, I'll be glad to
offer as much help as possible. 

