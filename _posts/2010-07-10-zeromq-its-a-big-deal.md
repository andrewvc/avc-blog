---
title: ZeroMQ, It's a big deal
layout: post
category: 
tags : 
---




ZeroMQ's got some interesting ideas, but unfortunately hasn't quite gotten the
press it deserves. I'm just starting to toy around with it, mostly due to Zed
Shaw's use of it in [Mongrel2](http://www.mongrel2.org). Regardless of Mongrel
2, ZeroMQ IS fascinating. Why? A few reasons. I'll get to some of them in a
bit, but first I'll let this short block of text from the[
ZMQ::Socket](http://zeromq.github.com/rbzmq/classes/ZMQ/Socket.html) class's
Ruby docs explain why:

> Generally speaking, conventional sockets present a _synchronous_ interface
to either connection-oriented reliable byte streams (SOCK_STREAM), or
connection-less unreliable datagrams (SOCK_DGRAM). In comparison, 0MQ sockets
present an abstraction of an asynchronous _message queue_, with the exact
queueing semantics depending on the socket type in use. Where conventional
sockets transfer streams of bytes or discrete datagrams, 0MQ sockets transfer
discrete _messages_.

>

> 0MQ sockets being _asynchronous_ means that the timings of the physical
connection setup and teardown, reconnect and effective delivery are
transparent to the user and organized by 0MQ itself. Further, messages may be
_queued_ in the event that a peer is unavailable to receive them.

>

> Conventional sockets allow only strict one-to-one (two peers), many-to-one
(many clients, one server), or in some cases one-to-many (multicast)
relationships. With the exception of ZMQ::PAIR, 0MQ sockets may be connected
**to multiple endpoints** using connect(), while simultaneously accepting
incoming connections **from multiple endpoints** bound to the socket using
bind(), thus allowing many-to-many relationships.

The full[ ZeroMQ Ruby docs](http://zeromq.github.com/rbzmq/) are a good read,
as are the papers on [http://www.zeromq.org/](http://www.zeromq.org/).

So, why else go ZMQ? Well, it's got interchangeable transports. ZeroMQ
supports ultra-fast inter-thread messaging, inter-process  communication, TCP,
and multicast, as supported transports.

These messages can be exchanged between any language that support ZMQ, at the
moment, that's all your faves, from C/C++ to Java, to Ruby, to Python, and
more.

Another good source for ZMQ info is [this excellent post](http://nichol.as
/zeromq-an-introduction) on Nicholas Piel's blog. Resplendent with diagrams
and wonderful explanations.

At any rate, I'm just getting started with ZMQ, as my ZMQ exploration
continues I'll update this blog.

