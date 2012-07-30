---
permalink: engulf3-http-api
title: Engulf 3 HTTP API Now Working!
layout: post
tags : [clojure jvm]
---

I've been working on the new version of my scalable HTTP load-tester engulf quite a bit lately, and it's getting very close to the 3.0.0 release! While the Web interface is still non-functional, the rest is in good shape, and fully functional. 

With v3 you'll be able to use a whole network of computers to orchestrate a single load-test with near zero setup. All you need is the engulf jar. You start a single 'master' node that orchestrates the affair, and then any number of workers that connect back to the master (see the [usage](https://github.com/andrewvc/engulf/wiki/Usage) page for details).

I'm particularly proud of the fact that the [HTTP API](https://github.com/andrewvc/engulf/wiki/HTTP-API) is now solid. It's a RESTful API with support for streaming realtime via both Websockets and chunked encoding. The entire tool can now be operated entirely with cURL!

Of the new features nearly all are done with the exception of the realtime browser GUI. In addition to a new API are several new features. The full feature list for v3 is:

* REST API *done!*
* More customization of test parameters *done!*
* Streaming API *done!*
* SQLite Recording *done!*
* New Browser Interface *in-progress*

If you're curious to check it out, grab a copy of the [master branch](https://github.com/andrewvc/engulf), and follow the [usage](https://github.com/andrewvc/engulf/wiki/Usage) instructions!