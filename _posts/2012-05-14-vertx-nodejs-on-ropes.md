---
title: 'Vert.x: Why the JVM May Put Node.js on the Ropes'
layout: post
tags : [nodejs, jvm, systems, clojure, vertx]
permalink: vertx-node-on-ropes
---

## It's Time for Change

We're beginning to see a turning point in asynchronous frameworks, specifically with regard to Node.js. My contention is that <strong>a dynamic language paired with a hybrid concurrency (async+threads) model is a better node.js than node.js</strong>.

Developers want a dynamic language with a clean syntax like Python or Ruby. They also want massively concurrent servers to deal with sleepy connections from websockets, comet, and the like.

With the JVM's rise as a polyglot platform, we're finally at a point where dynamic languages can use the great threading support the JVM has to offer. Additionally, with the recent debut of [Vert.x](http://vertx.io/) we're finally at a point where that software is packaged together is such a way as to be extremely practical. 

Vert.x is an asynchronous application server, essentially Node.js+ for the JVM. The chart below shows why I think Vert.x has the right mix of features to make a big impact:

<table>
  <thead>
    <tr>
    <th></th>
    <th>Vert.x<br/>(Polyglot JVM)</th>
    <th>Node.js<br/>(Javascript)</th>
    <th>Netty<br/>(Java)</th>
    <th>EventMachine<br/>(Ruby)</th>
    <th>Twisted<br/>(Python)</th>
    <th>LibEvent<br/>(C)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
     <td class='desc'>Language Type</td>
     <td class='highlight'>Dynamic or Static</td>
     <td class='highlight'>Dynamic</td>
     <td>Static</td>
     <td class='highlight'>Dynamic</td>
     <td class='highlight'>Dynamic</td>
     <td>Static</td>
   </tr>       
   <tr>
     <td class='desc'>Speed of Development</td>
     <td class='highlight'>Fast</td>
     <td class='highlight'>Fast</td>
     <td>Slow</td>
     <td class='highlight'>Fast</td>
     <td class='highlight'>Fast</td>
     <td>Slow</td>
   </tr>       
   <tr>
     <td class='desc'>Threading Support</td>
     <td class='highlight'>Great</td>
     <td>None</td>
     <td class='highlight'>Great</td>
     <td>Poor</td>
     <td>Poor</td>
     <td class='highlight'>Good</td>
   </tr>       
   <tr>
     <td class='desc'>Library Threadsafety</td>
     <td class='highlight'>Good</td>
     <td>N/A</td>
     <td class='highlight'>Good</td>
     <td>Poor</td>
     <td>Poor</td>
     <td class='highlight'>Good</td>
   </tr>       
   <tr>
     <td class='desc'>Backed By</td>
     <td class='highlight'>VMware</td>
     <td class='highlight'>Joyent</td>
     <td>N/A</td>
     <td>N/A</td>
     <td>N/A</td>
     <td>N/A    </td>
   </tr>       


</table>

## An Argument for Hybrid Concurrency

Node.js takes the position of only using asynchronous IO. The pseudo-code below contrasts an asynchronous implementation with a hybrid implementation. Take a quick gander at it, we'll compare and contrast below.
    
    # Pure Async
    messages_counter = 0
    on_receive = fn (msg, connection) {
      messages_counter += 1
      db.write({m: msg, cnt: message_counter}, fn (success) {
        connection.send("write result")
        db.read("something_dependent", fn (result) {
          connection.send(format_result(result))
        }, fn (error) {
          connection.send("DB Error " + error)  
        }
      }, fn (error) {
        connection.send("DB Error" + error)
      }
    }
    
    # Hybrid
    threadpool = new FixedThreadPool(System.cpus*2)
    messages_counter = new AtomicInteger 0 
    on_receive = fn(msg, connection) {
      msg_num = messages_counter.getAndIncr
      threadpool.execute( fn () {
        try {
          db.write({m: msg, cnt: message_counter})
          res = db.read("something_dependent")
          connection.send(format_result(result))
        } catch (DBError error) {
          connection.send("DB Error " + error)
        }
      }
    }


It's my contention that the hybrid example is both easier to read, and has more desirable performance characteristics. The reasons being that the hybrid model:

* **Uses Async where it works best, threads where they work best**: Async is used for connection handling where it works best, synchronous threads are used for app logic where they work best
* **Optimizes concurrency by tuning**: Optimal concurrency can be achieved by adjusting threadpool sizes, types, and priorities. In a reactor there are fewer options since there is a single global queue.
* **Doesn't block on slow code**: If in the code sample above the `format result` method's runtime is variable, occasionally running slowly, the thread scheduler will ensure that it doesn't block all program's threads. In the real world this helps ensure QoS.
* **Shares data using language features**: The language's concurrent datastructures can be used for data shared across cores (the `messages_counter` variable in this case)
* **Uses the language's exception handling**: Try/catch is easier and often more simple than checking each callback.

While node.js does have solutions to most of these problems, they are generally awkward to use. Some of the more common refrains, and my responses to them are:

* **But you can load balance across multiple processes in node!** This is only gets you granularity at the per-connection level. One bad client can ruin all the connections to that particular server instance, it can't leverage additional cores or schedule other jobs ahead easily.
* **But you can use message passing to coordinate between processes, who needs shared memory!** This is true, and for most languages this is generally a good idea. However, since it isn't built into the language the syntax is messy and the performance could be better.
* **But you can use fibers/coroutines to get blocking-looking async code!** You're still effectively managing threads manually, playing human process scheduler. Additionally you still need to know which calls are blocking and which ones aren't otherwise you'll have race conditions when what *looked* like blocking code wasn't. In both threaded and callback styles these issues stick out.
* **But if all the libraries aren't async its easy to block the async parts of a hybrid system!** While this is a valid concern, most libraries are pretty clearly blocking or non-blocking. I haven't seen this become an actual issue. To use blocking libraries, simple defer their processing to a background thread.

## Why Vert.x Has the Right Mix

One might say that if all Vert.x consists of is Netty+Hazelcast, that it's nothing revolutionary. The reality is that Vert.x gets the API right, which most of the existing JVM tools get very.... very... wrong. Even simple services in Netty takes large amounts of code, an inordinate of factories, providers, and threadpools must be created just to do simple things. Mixing all this up with languages like jruby is just prohibitively painful. APIs can be as hard to design as implementations are to write!

On top of the API, the other half of the secret sauce is in Vert.x's leveraging of high performance implementations of Ruby, Javascript, and Groovy. By integrating them into a single Vert.x executable, they've given developers the ability to write high-performance code on the JVM without knowing much about the JVM or its ecosystem at all. Vert.x can run *any* of those languages directly. Furthermore, since Vert.x is just a library, any JVM language can leverage it. On top of that, the entire universe of JVM libraries, concurrency APIs, and tooling is available to developers.

I'm also glad to see that Vert.x has made [documentation](http://vertx.io/docs.html) a high priority. Many open-source projects flounder here, failing to pick up steam as users too confused to use it. By building a great site and set of docs they've set themselves up for success.

For those who are even more keen on high concurrency, Vert.x plays well with Scala and Clojure. These are both languages that were designed for multicore, something that cannot be said for JavaScript.

Lastly, Vert.x has deep reliance on event driven programming. By leveraging Hazelcast, a high performance, network and in-memory event bus, encapsulation and single responsibility can be archieved simply and cleanly. This works particularly well when integrating async socket logic with synchronous background threads.

## Why Ruby and Python are Ill Suited for Hybrid Concurrency

Both Ruby and Python have good reactor implementations, in EventMachine and Twisted/Tornado respectively. However, neither language works well in a Hybrid model for two reasons:

* A GIL preventing true multicore execution (multiple threads for IO Wait, not for executable code).
* Poor async/concurrent library ecosystems

Both of these languages have the issue of having rather small async ecosystems. Additionally, since their most popular VMs don't handle threading well, the thread-safety of popular libraries is not tested much at all.

Running on top of Vert.x however, one can simple call Java libraries, which are generally threadsafe, from Ruby. You get the syntax of Ruby with the power of Java.

## Where it Doesn't Matter: Those Using Node.js for the JS

Now, a large part of Node.js's success is in simply being JS that runs server-side. If having a unified language across server and browser is your main concern, Node.js is definitely the way to go. However, I would caution that JS is just not as nice a language as Ruby, Scala, Clojure, Java, etc. IMHO. For large codebases it gets tiresome and unwieldy.

Additionally, the stated benefits of one language across cliend and server are invisible to me. For security and practical reasons its hard to share a meaningful amount of code across both.

## Polyglot Friction

There are some concerns with the polyglot approach Vert.x is taking. Foremost among them is that ripping languages like ruby and javascript from their normal environments can be confusing to developers. This means that developers need to learn alternate ways of setting up their systems and installing packages. It also means learning enough Java to leverage JVM libraries where native jruby/commonjs wrappers may not exist. It is for this reason that JVM native languages like Clojure, Groovy and Scala have perhaps the brightest long term future on this platform.

## For the Curious, Some Context

If you've gotten this far, you might be curious as to why reactors came to be, and why node.js wound up using the reactor pattern in the first place. To provide that answer let's look a bit at the past and what reactors were born into this world to do. The two most common places you'll find a reactor are:

* Handling GUI Events
* Handling Network connections

While these two things might *seem* extremely different, they actually share a common thread (pun intended), **both GUIs and sockets have a large number of mostly idle event sources**. It's no accident that Javascript, a programming language designed to script GUIs is also a damn good language for handling large numbers of sockets. **Evented programming is a solution to aggregate a large number of events from different sources onto a single thread.**

Reactors give you two distinct advantages over thread-per-connection:

* Less Required Memory: You don't need a full thread/stack for each event source
* No Need For Threadsafe Libraries: Single-threaded execution obviates concurrent libs

For these cases asynchronous programming rocks. For many others, it most definitely does not rock. Here are some of the costs of this model:

* Limited to a single core per process
* CPU intensive code must be manually scheduled
* Callback heavy, ugly code

The last point, about ugly callbacks is the *least* important point on that list. I'm limiting the discussion there as it has a propensity to start a flamewar. Let's talk about the first two points then.

That a reactor can only run on a single core is an obvious limitation, that CPU intensive code must be manually scheduled on a reactor is less obvious. What this means is that if you do something that takes up a lot of CPU time, like rendering a complex PDF for instance, you will block the entire reactor for that period of time. No other requests can be serviced while that occurs.

This leaves the asynchronous programmer with only one option to keep that work in-process, and that option is to break up the work into chunks. These chunks must be small enough to make the server appear to be serving multiple requests simultaneously, and must also only enqueue a small number of new chunks of a similar size so as not to flood the queue. At this point the programmer has become a human process scheduler. Not fun.

Humans are terrible at scheduling processes for two reasons: 1.) We're generally not as smart as the thread scheduling algorithms in a kernel 2.) An OS can decide to schedule threads based on what's happening at runtime, that can't be easily done while writing the code.

Additionally, reactors require you to spawn multiple processes and use a load-balancer to use the other cores in your machine. The downsides of this strategy are that: 1.) it is more operationally complex 2.) it is hard to divert work from a process with particularly active connections to those with less active ones for connection based protocols (e.g. web sockets).

The entire notion of asynchronous programming is built upon facilities that fit the performance profile described earlier, of sockets and GUI inputs. Both of these things really spend most of their time asleep. Your OS kernel provides a special performance optimized system call for these situations, on linux systems its called [epoll](http://linux.die.net/man/4/epoll). epoll helps asynchronous code run like a champ. Your server's linux kernel is meant to handle a ton of sleepy connections and epoll lets your single reactor thread pluck only the active ones from that list as quickly as possible.

This model is great for large numbers of sockets and file descriptors, where it makes the best use of resources. However, it's very confusing and complicated when it comes to day to day business logic, where simple, blocking, threaded code is a welcome comfort.

## A Note on Concurrent Programming in General

I would be remiss not to mention that concurrent programming is hard. Very hard. Really, it's nearly impossible to truly get right. It's easy to view tools as a panacea, but the reality is that modeling concurrent problems correctly and then implementing them correctly requires discipline, patience and skill. It's clearly my belief that we have something special in Vert.x, but that doesn't mean it isn't a only a matter of time before something better comes along.