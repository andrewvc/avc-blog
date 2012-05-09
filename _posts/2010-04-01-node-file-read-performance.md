---
permalink: node-file-read-performance
layout: post
category: 
tags : ['nodejs']
title: Node File Read Performance
---


In my last post, I demonstrated the impressive scalability of Node.js, and more generally, the scalability of the evented model, whereby increasing concurrency barely affects total throughput. You may have noticed however, that 1000 reqs took about 17 secs giving us 58 reqs/second. That's pretty bad, but this is mostly reflective of node's slowness when transferring in binary mode. Apparently the same test today runs twice as fast, but more interestingly, performance was further dramatically improved by reducing the chunk size of reads from ~500 KiB (the full file size) to the default size of 4 KiB. The larger chunk size took 44% more time, I'm using fs.createReadStream to perform the reads, and on each read the data is written out to the client. The smaller chunk size means that for that 500 KiB, res.write() gets called 125 more times, yet that doesn't even seem to matter. That means, in terms of total throughput, I was able to reach ~ 150 res/second, or ~10 MiB / Second, a pretty decent improvement. While a big improvement from previous numbers, node really is not a speed demon when it comes to serving files.
 
I'm not exactly sure why this is faster, but I have a hunch that this has to do with the fact that binary data in Node.js (and V8) needs to be represented in UTF-16, and/or the fact that string concatenation is worse than O(n), I'm not sure what it is in V8, but I would have to guess that flushing data more frequently into the kernel buffer (which I'd guess from my horribly limited and outdated and limited kernel networking knowledge is O(n)) is vastly more efficient. I've got no idea how efficient UTF-16 conversion is, but it doesn't sound fast at all.
 
Strangely, those same benchmarks I ran yesterday seem to be running twice as fast in terms of throughput, and I don't know why, since I changed nothing, and the server was unloaded. The 44% improvement is still present when I change the chunk size, but there must have been some unknown factor I missed.

