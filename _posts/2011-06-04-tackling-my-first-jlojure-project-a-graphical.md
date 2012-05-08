---
title: Tackling my first Clojure project, a Graphical HTTP Benchmarker
layout: post
category: 
tags : 
---




I've been bits of my free time working on
[parbench](https://github.com/andrewvc/parbench)&nbsp_place_holder;over the
last month, a visual version of the venerable 'ab' (apache-bench) HTTP load
testing tool as a way to get up to speed on clojure. It's been a fun project
as far as getting up to speed, and I thuoght I'd share what I've learned about
clojure and its ecosystem.

Let's walk through the tool first, basically, you run it against an URL like
'ab', and it shows, in real time, your requests being executed. Each
horizontal line is a 'user', and each square is a request, it fills from left
to right as each user goes through its requests.

[![Screenshot-parbench](./images/55648729-0-Screenshot-
Parbench.png.scaled500.png)](./images/55648729-0-Screenshot-
Parbench.png.scaled1000.png)

**Structuring the App**

I'm a ruby programmer by day, and the structure here was a bit different than
I'd structure a ruby app, as classes / objects aren't generally used in
Clojure code. Rather, the organizing principle is the namespace, and the
philosophy behind Clojure is functions operating on core datastructures, or
things like defrecord, which, while POJOs in implementation, mimic the core
map type.

Clojure has very strong opinions about concurrency, it hasimmutable
(persistent) datastructures, software transactional memory, actors, and much
more in its bag of tricks. Nothing is mutable in clojure without a fair amount
of explicitness. Rather than being encumbering, its actually refreshing, as
you spend less time worrying about contention and race conditions.

To get a better feel for how a Clojure program might be built, lets break down
parbench. The overall flow of parbench is split into two parts, the http
request engine in [benchmark.clj](https://github.com/andrewvc/parbench/blob/ma
ster/src/parbench/benchmark.clj)&nbsp_place_holder;and the console and GUI
output functions in [displays.clj](https://github.com/andrewvc/parbench/blob/m
aster/src/parbench/displays.clj). A brief overview follows:

**benchmark.clj:**

  * Initialize a 2d array (vectors actually) of refs, each representing a request. A 'ref' being a wrapper around a persisent datastructure allowing you to change its state in a transaction. Transactions here work almost exactly like database transactions. This is referred to as the 'grid' in parbench.
  * Each row in the grid is a simulated user-agent, and should execute one request at a time. Each row gets its own backing thread via a Clojure future, which is basically a fancy Java thread. &nbsp_place_holder;Since I'm using an asynchronous Netty based http-client from [Sonatype](https://github.com/sonatype/async-http-client)&nbsp_place_holder;it is possible, even optimal, to do this all in a single thread rather than thread per-user, but this was more straightforward.
  * As requests change state, the hashes representing their current state, nested in the grid, are mutated inside a transaction demarcated using dosync.
  * There's a weird function, block-till-done, that polls the grid and checks to see if all requests are completed, if they are it stops blocking. While this isn't optimal with a bunch of threads, each of which could simply signal when it complete, I went with this method with a previous concurrency model, and its very flexible letting me try out different concurrency models without worrying about housekeeping.

**displays.clj:**

  * The GUI uses [processing](http://processing.org/)&nbsp_place_holder;for display. The UI is initialized before the benchmarks, this is important, as it blocks until its first full render, letting the JVM and UI get pre-warmed so they don't impact results too much.
  * Due to clojure's refs, the UI always sees the grid in a consistent state, since all mutations to the request refs are transactional inside those dosyncs we spoke about earlier.
  * The console output uses a java TaskTimer to regularly print output to the terminal, iterating over the datastructures.

**Impressions of Clojure and the its ecosystem**

  * **It's an active community** with a vibrant, supportive, and fun group of members, which is good, because there's a lot of work to do.
  * **There's a dearth of documentation for libraries.** A lot of the code you'll need is on github, and a lot of it requires diving into the source to figure out the full API. It's somewhat expected in a community this young, but it's a bit of a drag on productivity.
  * **There aren't enough blog posts about Clojure, **problems just aren't that googleable in clojure at the moment. A lot of the common ones are, but a lot of roadblocks require you to roll up your sleeves and experiment.
  * **Sequences, and the functions around them are elegant and powerful,** though there is a bit of a learning curve, it isn't too bad. There are many powerful tools in Clojure to work with sequences, and they are one of the things that makes clojure an absolute joy to work in.
  * **It's all about the datastructures, **while clojure now has more integrated java objects with defrecord and friends, the core data-structures are extremely powerful and easy to use.
  * **Clojure is concise**, though it can become impenetrable at times. This makes breaking up functions extremely important. The same conciseness that gives it its beauty can be its undoing.
  * **You need to know Java.**&nbsp_place_holder;I'd hoped to learn clojure without learning any Java, it didn't take long to figure out that was a terrible plan, and I had to spend a while learning some basic java first. Clojure leans heavily on java for its library support, and some libraries don't yet have clojure wrappers. Luckily, java interop is so good in Clojure, it isn't an issue to go back and forth most of the time.
  * **Get the [Joy of Clojure](http://joyofclojure.com/),**&nbsp_place_holder;it's a great book. The online resources for learning Clojure are scattered and hard to piece together into a consistent whole.

Overall, Clojure's becoming my free time language of choice because it's
concise, expressive, and elegant. It's also a good departure for those coming
from more OO languages, and will definitely work different muscles in your
brain.

Lastly, I'm pretty new to Clojure, I'm pretty sure parbench's code sucks in
myriad ways. Got some ideas as far as improving it? Let me know!

