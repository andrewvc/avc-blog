---
permalink: fork2-is-dead-long-live-fork-i-mean-clone2
layout: post
tags : [ops, systems]
---


While browsing Hacker News today I stumbled across an interesting article with one odd factual error. It claimed that fork(2) is not a system call. Now, the fact that  it's fork(2), not fork(3) is a dead giveaway that fork is indeed a system call, however, this lead me down an interesting path exploring how fork is actually implemented in the Linux kernel, and enlightened me quite a bit to the distinction between threads and processes in the Linux Kernel.
So, the first thing I discovered is that fork does not in fact fork anymore. Quoting man 2 fork:

> Since version 2.3.3, rather than invoking the kernel's fork() system call, the glibc fork() wrapper that is provided as part of the NPTL threading implementation invokes clone(2) with flags that provide the same effect as the traditional system call. The glibc wrapper invokes any fork handlers that have been established using pthread_atfork(3).
We can actually test this out, and see that this is, in-fact, the case. First, I grepped the linux header unistd_64.h to check what the number the fork system call maps to. Since glibc wraps the fork function around clone() instead, we'll have to call it by number, not name.

    #See which number the fork(2) system call actually is
    $ grep fork /usr/include/asm/unistd_64.h     
    #define __NR_fork				57
    __SYSCALL(__NR_fork, stub_fork)
    #define __NR_vfork				58
    __SYSCALL(__NR_vfork, stub_vfork)

    #strace shows us that fork is indeed not seen anywhere, just as man 2 fork said
    $  strace -f ruby -e 'fork' 2>&1 | egrep -A1 '^(fork|clone)'
    clone(Process 4281 attached
    child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f2b01ad89f0) = 4281

    #strace shows us that fork(2) can be called if manually specified
    $ strace -f ruby -e 'syscall 57' 2>&1 | egrep -A1 '^(fork|clone)'
    fork(Process 4259 attached (waiting for parent)
    Process 4259 resumed (parent 4258 ready)

Well, that was interesting, I wondered what `man 2 clone` has to say for itself...

> clone() creates a new process, in a manner similar to fork(2). It is actually a library function layered on top of the underlying clone() system call, hereinafter referred to as sys_clone. A description of sys_clone is given towards the end of this page. Unlike fork(2), these calls allow the child process to share parts of its execution context with the calling process, such as the memory space, the table of file descriptors, and the table of signal handlers. (Note that on this manual page, "calling process" normally corresponds to "parent process". But see the description of CLONE_PARENT below.)

We can see that clone is called with the args:

    "child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f2b01ad89f0)

and returns the int thread ID of the child process to the parent. Now, we see here that the child_stack is set to 0, something which is ONLY valid for sys_clone, which will then automatically allocate stack space for the child. The rest of the flags automatically perform some housekeeping referencing the child_tidptr as described below: 

* **CLONE_CHILD_CLEARTID:** Erase child thread ID at location ctid in child memory when the child exits, and do a wakeup on the futex at that address.
* **CLONE_CHILD_SETTID:** Store child thread ID at location ctid in child memory.
* **SIGCHLD:** the termination signal sent to the parent when the child dies (in this case SIGCHLD).

You may notice that the child_stack is set to 0, which is a reminder that we've actually called sys_clone, which can take zero as a location for child_stack. Sys clone will automatically allocate stack space for you, as well as automatically start execution at the point it was called from, rather than forcing you to point it at the instruction to start at. 

As an aside, at this point you may be asking what a futex is (referenced from CLONE_CHILD_CLEARTID). After a little research I discovered that a futex(7) is a Fast Userspace Mutex which can be used to communicate between processes or threads sharing memory. The thing about futex's is, they can run mostly in userspace, except in the case of contention, in which case a syscall to futex(2) is made to arbitrate.

So, with that in mind lets break down what these flags and see what's happening. First lets look at what the three flags that were specifed do:

1. Store the child thread ID at the address specified by child_tidptr
1. Issuing a wakeup on the futex (possibly for pthread_atfork, but I'm not sure exactly)
1. Send SIGCHLD to the parent (notifying the parent the child has exited)

There are a couple things missing from this picture however. How about copy on write semantics? If clone is used for both threads and processes, then there should be something about CoW in there. For those of you who may not know about CoW, when you fork a process, linux makes a second copy of the process, but doesn't duplicate its memory, the two processes share memory until one of them writes to a segment of memory, at which point the altered memory is allocated new space, that's only visible to the process that wrote to it. So, forking off copies of a program requires very little memory so long as the children don't alter much memory.

So, there's a flag that controls this:

**CLONE_VM:** If CLONE_VM is set, the calling process and the child process run in the same memory space.

As we saw above, this option was not set, so the memory space was cloned. If you read further in man clone, you'll see that leaving CLONE_VM unspecified results in CoW semantics.

There's one other thing missing from this puzzle, clone mostly talks about threads, not processes. Why does the call to clone above create a new process, and what's the difference anyway? Well, it turns out that threads and processes aren't that different under Linux post-NPTL anyway (we'll get into NPTL in just a little bit). To see how this works lets look at another omitted flag to clone:

**CLONE_THREAD:** If CLONE_THREAD is set, the child is placed in the same thread group as the calling process.

Apparently a process is just a thread with its own PID/TGID(Thread Group Identifier) in Linux. Threads are just threads that share a process, and are grouped under a TGID, which is the PID of the process that spawned the threads. I was a bit surprised to see that the traditional notion of a UNIX process now shares an implementation with threads.
 
The next question I had is, why even use clone instead of fork? Well, according to the clone man-page NPTL (Native Posix Thread Library) provides clone so let's read into that. I hadn't heard of NPTL before, so I thought I'd see what Wikipedia had to say:

> Before the 2.6 version of the Linux kernel, processes were the schedulable entities, and there was no real support for threads. However, it did support a system call — clone — which creates a copy of the calling process where the copy shares the address space of the caller.

It goes on to say...

> NPTL uses a similar approach to LinuxThreads, in that the primary abstraction known by the kernel is still a process, and new threads are created with the clone() system call (called from the NPTL library). However, NPTL requires specialized kernel support to implement (for example) the contended case of synchronisation primitives which might require threads to sleep and wake again. The primitive used for this is known as a futex

If we look a little further, back in man 2 clone we see:

>  Unlike fork(2), these calls allow the child process to share parts of its execution context with the calling process, such as the memory  space,  the  table of file descriptors, and the table of signal handlers.  (Note that on this manual page, "calling process" normally corresponds to "parent process".  But see the description of CLONE_PARENT below.)

So, basically fork really only performs a subset of the functionality of clone. clone(2) is the go-to syscall for creating threads, and since processes are basically a special case of a thread in Linux these days, we may as well use clone instead.