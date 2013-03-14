---
permalink: a-benchmarking-crawler-in-clojure
title: A Benchmarking Crawler in Clojure
layout: post
tags: ['clojure', 'jvm', 'rails']
---

I recently wrote a benchmarking crawler, [crawl-bench](https://github.com/andrewvc/crawl-bench) in clojure, specifically targeted at profiling Rails apps with rack-cache. 

The crawler reports the speed of requests at the 10th, 50th, and 95th percentiles. It collects two sets of data, 1.) end-to-end time to issue the HTTP request and get a response, 2.) the time reported by x-rack-cache. It also lists the 10 requests with the slowest rack-cache times. 

The spider is a pretty good way to get some additional numbers on the impact of Heroku's recent routing issues. I've seen a large discrepancy between the end-to-end times and the internal page rendering times.

To run it you'll need to [download the jar](https://s3.amazonaws.com/andrewvc-misc/crawl-bench-0.1.0-SNAPSHOT-standalone.jar), To run crawl-bench simply run: `java -jar crawl-bench.jar <number-threads> <base-url> <regex-to-match>`. An example might be `java -jar crawl-bench.jar 5 http://my-site.domain/crawl-content/ '.*/crawl-content/.*'`. Which would limit crawling to that sub-folder. Please note that percentile stats are incorrect until >= 100 URLs have been crawled.