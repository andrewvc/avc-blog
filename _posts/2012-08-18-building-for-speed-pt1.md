---
permalink: /engulf-building-for-speed-pt1
title: Engulf - Building for Speed. Part 1
layout: post
tags : [systems, clojure]
---

On and off For the past year I've been working on a pet open source project, [Engulf](http://engulf-project.org), a high-performance distributed HTTP load tester. I'm excited to say that its 3.0 release is nearly ready. A lot has gone into this release, and I'd like to share some of the architectural decisions that went into Engulf.

For many apps performance is a nice to have, but in a load tester it is a requirement. There is no way around it. To that end, Engulf is built for speed and predictability . In this series of blog posts I'd like to explore some of the design decisions I've made.

## Clients and Servers, Map and Reduce

At its core and Engulf is a networked map-reduce framework with a single app--an HTTP benchmark job--running on it. A load tester is a perfect example of map-reduce. Workers can operate autonomously, and their results can be combined in any order. Furthermore, much of the processing can be pushed out to the edges versus having to take place in a central location.

As a rule it is generally better to have as much work done in the map phase as possible, rather than in the reduce. Parallelizing the reduce phase is considerably more difficult. Given Engulf's master/worker architecture, it may seem that all the map phase work is performed on the workers and reduce phase work is performed on the master. However, for efficiency each worker performs some partial reductions before sending data back to the master.

Consider that many of the mathematical operations that  involved in producing statistics for HTTP benchmarks are variations on sums. For instance, while only a single node may compute an average because it involves division, that operation is O(1), while adding up the various results is O(n), but can be distributed across the workers. The order in which these operations occur does not matter. In other words, most of our operations are commutative.

To that end, each worker only transmits data back to the master on a fixed interval of 250ms. That frame of data does not contain much in the way of individual results, it contains mostly summaries of individual results. Let's explore how two of the stats are calculated, those for the two graphs (percentiles and throughput/time) in engulf's UI.

## Being Efficient Withi Time and Space.

Let us--as an example--examine the way Engulf handles data relating to throughput over time, which is the bottom graph in the UI (check the [project website](http://engulf-project.org) for a screenshot. The key to handling this well is quantization. Quantization lets us constrain our processing time and storage space leading to desirable scaling characteristics. A benchmarker's performance profile should be as predictable as possible, otherwise it's impossible to trust its results.

To that end, workers quantize the timestamps of all results. For instance, a sequence of response time data indicating when a given request starts and stops might be quantized from this:

    [{:start 0, :stop 10}, {:start 5 :stop 12}, {:start 800 :stop 960}, {:start 850 :stop 900}]

into:

    [{:start 0 :count 2 :total 17}, {:start 500, :count 2 :total 210}]

We can represent all the information we care about with an acceptable loss of accuracy. In this case reducing our time resolution to half seconds from milliseconds. Additionally, this work can be done on the workers, and the results from various workers can be quickly merged to gether on the master.

There is however an issue even with this. While this strategy works for workers, which as I mentioned previously, send data once every 250ms, it is problematic for storage and processing on the master. This is duet to the fact that the master must record all time slices from the start of the job to the end. Handling a growing corpus of data will become incrementally slower, as the number of time-slices increases.

To that end, the master adaptively quantizes all received data. While workers always use a fixed 500 ms quantization interval, the master uses a progressively longer quantization interval to ensure a relatively constant and low processing requirement. To accomplish this, the master progressively doubles its quantization interval, moving from 500ms, to 1000ms, to 2000ms, etc., as the number of buckets passes a preset threshold (in Engulf's case, 100). If you watch the UI you'll notice the bars on the time-series chart getting more numerous then suddenly halving. This is re-quantization taking place. This is also advantageous when it comes to storing results permanently, all runs take about the same amount of space!

The algorithm for calculating the acceptable bucket sizes is somewhat interesting in that it involves a round to the nearest power of two, since we would lose accuracy re-quantizing otherwise. The implementation can be [found here](https://github.com/andrewvc/engulf/blob/master/src/engulf/formulas/http_benchmark_aggregations.clj#L101). Note, this can be done faster w/ bit shifting, but it is executed rarely (a few times per second), so the speed gain would be negligible.

## Being Verbose for Efficiency

Some of Engulf's speed comes from a its compact representation of percentile data. Recording percentiles requires keeping all samples in a non-lossy format. Data cannot be quantized as it is with throughput or response times. The initial version of this implementation involved maintaining a vector of every response time received and occasionally sorting it to run statistics on it. With any test of even moderate length this became quite slow and began to dominate CPU time. [O(n log n)](http://en.wikipedia.org/wiki/Merge_sort) adds up quickly. The optimization I will present reduced CPU time to near nothing, and reduced the memory requirements to a constant amount.

While the workers do in fact send a full list of their response times for the 250 ms intervals each worker frame represents, the master node does something quite different. The trick is efficient representation. Engulf achieves this by exploiting the fact that its HTTP requests terminate in a finite amount of time or fail. 

Rather than initialize a vector that starts empty and accumulates results, Engulf initializes an int[90000] on each job start. Each element in the array represents 1 ms, and is incremented based on the number of requests that took that amount of time. The maximum number of milliseconds that can be recorded is 90,000. Thus, the array represents buckets of request completion times. 

If a request takes longer than 90 seconds it will not be recorded, but then if your service is taking 90 seconds to return you probably don't need a high-performance benchmark to test it out. Even if longer times are required the same technique can be expanded by using a logarithmic scale, at a slight loss of precision (this may come in a future version of engulf).

## Till Next Time

Well, that wraps up part one of this series, I hope to have part two ready soon!