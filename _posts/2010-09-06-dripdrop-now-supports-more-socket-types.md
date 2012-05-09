---
permalink: dripdrop-now-supports-more-socket-types
title: DripDrop now supports more socket types.
layout: post
tags : [ruby]
---




My DripDrop framework for zmqmachine/EventMachine just saw a whole bunch of
ZMQ improvements, it now supports PUSH/PULL and XREQ/XREP in addition to
PUB/SUB sockets. Also, the ZMQ handlers have been completely refactored to be
much cleaner, making adding additional socket types much easier.

[http://github.com/andrewvc/dripdrop](http://github.com/andrewvc/dripdrop)

Checkout the examples folder for usage.

