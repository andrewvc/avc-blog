---
permalink: some-jvm-concurrency-reading
title: Misc. JVM Concurrency Reading
layout: post
tags : java jvm concurrency
---

Some interesting stuff has all seemed to jump across my screen over the past few weeks regarding JVM concurrency. Here's a brief run-down:

* [The LMAX Architecture](http://martinfowler.com/articles/lmax.html): A speed system for processing transactions
* [Lock-free Algorithms Talk by LMAX guys](http://www.infoq.com/presentations/Lock-free-Algorithms#HN2): An explanation of some the hardware and software side of lock-free algorithms
* [Quest for the Optimal Queue](http://cs.oswego.edu/pipermail/concurrency-interest/2012-May/thread.html#9354): A brief but interesting thread including a brief comparison of some java.util.concurrent queues with the LMAX Disruptor's ring buffer
* [Improvements in jdk8 ConcurrentHashMap instances](http://cs.oswego.edu/pipermail/concurrency-interest/2012-June/009505.html) A discussion on some new under the hood changes for the JVM's concurrent HashMap

The top three links are all in some way related to the [Disruptor](http://code.google.com/p/disruptor/) framework used at LMAX. 

The last link about the changes to ConcurrentHashMap is interesting because we generally think of hash maps as O(1). Here, they're changing what is perhaps the most used HashMap implementation in the world to degrade to O(log(N)) in some scenarios.

What's particularly interesting about this HashMap revamp is that it helps resolve a class of security vulnerabilities around overflow bins in HashMaps when the keyspace has a large number of collisions. This ties into [this sort of vulnerability](http://cryptanalysis.eu/blog/2011/12/28/effective-dos-attacks-against-web-application-plattforms-hashdos/), whereby attackers can craft special query parameters designed to create HashMaps that act more like O(n) lookup linked lists, and cause a DoS by causing a hash of query parameters to become extremely slow.

There are other fixes for that particular vuln (creating a random hash salt at app startup is the way ruby does it), however, Doug Lea's approach is interesting, and perhaps better in that it handles the general case of excessive hash collisions in an elegant way by using a tree-map-like structure to handle those cases, instead of the standard linked list.