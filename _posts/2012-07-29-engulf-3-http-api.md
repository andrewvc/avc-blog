---
permalink: engulf3-http-api
title: Engulf 3 HTTP API Now Working!
layout: post
tags : [clojure jvm]
---

I've been working on the new version of my scalable HTTP load-tester engulf quite a bit lately, and it's getting very close to the 3.0.0 release! I'm particularly proud of the fact that the [HTTP API](https://github.com/andrewvc/engulf/wiki/HTTP-API) is now solid, and quite fast.

It's a RESTful API with support for streaming realtime as well (both Websockets and chunked encoding). The entire tool can now be operated entirely with cURL!

Of the new features nearly all are done with the exception of the realtime browser GUI. In addition to a new API are several new features. The full feature list for 3.0.0 is:

* REST API *done!*
* Streaming API *done!*
* SQLite Recording *done!*
* New Browser Interface *in-progress*

If you're curious to check it out, grab a copy of the [master branch](https://github.com/andrewvc/engulf), and follow the [usage](https://github.com/andrewvc/engulf/wiki/Usage) instructions!