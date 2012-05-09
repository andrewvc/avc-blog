---
permalink: thanks-chuck-ffi-rzmq-and-zmqmachine-gems-rel
title: Thanks Chuck! ffi-rzmq and zmqmachine gems released. 1.8.x compat as well!
layout: post
tags : [ruby]
---




Big thanks to Chuck Remes for releasing the [ffi-
rzmq](http://github.com/chuckremes/ffi-rzmq) and
[zmqmachine](http://github.com/chuckremes/zmqmachine) gems on
[rubygems.org](http://rubygems.org). This also makes ffi-rzmq 1.8.7
compatible. I haven't had a chance to test this out much (and neither has
Chuck, thanks for humoring me w/ this patch Chuck!), but it seems stable to
me. This is great news for my new project
[dripdrop](http://github.com/andrewvc/dripdrop) (which is still in a very
tumultuous phase right now), and the ruby mongrel2 driver
[m2r](http://github.com/perplexes/m2r) .

ffi-rzmq definitely seems to be the preferred way of connecting to ZMQ with
ruby. Don't, however skip the official [rbzmq
docs](http://zeromq.github.com/rbzmq/), which are a fantastic intro do ZMQ
intself.

