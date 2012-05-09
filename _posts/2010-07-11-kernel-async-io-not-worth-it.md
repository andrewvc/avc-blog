---
permalink: kernel-async-io-not-worth-it
layout: post
tags : 
---

I'm currently preparing my slides for my presentation about async IO at next week's Los Angeles Hacker News meetup, and in the process stumbled across this interesting thread on kernel  AIO on the libevent mailing list. This segment of a post from William Ahern stood out in particular. To put this in context, the question is whether to use the kernel's own AIO API, or just roll your own with your own threadpool using one blocking call per thread.

> There are many ways to do AIO. I know of none that don't use threads, either kernel threads or user process threads. Now, the threads could be "light weight", but there's still a calling context that blocks on an operation. But no implementation is equivalent to, say, how the socket subsystem [state machines] work, where the only state that needs to be maintained is a queue of waiting objects (where object != thread). To put it simply, all the AIO implementations use too much memory and do too much book keeping (like thread scheduling) than strictly necessary, because kernels don't have a way to to "poll" on VM pages (as opposed to polling on disk interrupts, which you can accomplish when do doing direct I/O).

From what I know, Node.js manages its own thread pool, as does Ruby's event machine (using Ruby green threads). If anyone has any more info on this just tweet me, @andrewvc with what you know.


John Morris Responded:

> AIO to raw disks (or O_DIRECT on Linux) can be implemented by calling to the disk driver's "strategy" routine. Completions are reported through an internal callback mechanism, so there is no need to create or manage threads. However, AIO to file systems and other devices is usually implemented using a pool of kernel threads.
> Typically, it is the big databases which use AIO directly to raw disks. Oracle, for example, manages their own disk devices and uses "thread free" AIO whenever possible.