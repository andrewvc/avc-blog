---
permalink: nodejs-can-really-scale
layout: post
tags : ['nodejs', async]
---

EDIT: The concurrency #s are accurate but in terms of speed, its actually faster by 150%, see [this post](node-file-read-performance) for more info.

Node JS really does scale, check out the following graph of performance for 1000 requests on an app I recently wrote for work (all times are in milliseconds, with a total of 1000 reqs). 

Each request has 1 memcached call and then a 500 kb file read (these happen in serial), which is then written to the socket. This is on a 2.33 Ghz xeon w/ 4 gigs of ram, unloaded, running ubuntu Karmic. The file is loaded in the OS cache since it gets hit so often, so HD performance doesn't affect this. I had to stop after 500 connections because node won't open 500 file descriptors at a time. The file sending was handled by my fork of node-paperboy.
 
This app always pegged a single core (node's evented design doesn't use SMP capabilities), I'd have to think that if you ran one node per-core you'd get even better performance, hopefully I'll have time later to setup haproxy as a load balancer and try this.
