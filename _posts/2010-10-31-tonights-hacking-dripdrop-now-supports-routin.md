---
permalink: tonights-hacking-dripdrop-now-supports-routin
layout: post
tags: [ruby, async]
---

DripDrop now supports routing, a feature sorely needed for more complex apps. It was pretty easy to implement by using ruby's singleton class. Here's the entire implementation:

<script src="https://gist.github.com/656192.js?file=routing_singleton.rb"></script>

I've also written a [full example](https://github.com/andrewvc/dripdrop/blob/master/example/combined.rb) showing how to use the new routing syntax.

A new minor point release of the gem will be out within the week, once I've been able to test the routing out a bit more to make sure I like the style.
