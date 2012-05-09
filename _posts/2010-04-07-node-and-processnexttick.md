---
permalink: node-and-processnexttick
title: Node and process.nextTick
layout: post
tags : [nodejs]
---

Coding in Node, or any evented setting, often requires different ways of
thinking. The primary difference being that you have to keep
track of _when_ the code you're writing
will run. I've really just started writing code in Node, below is a
clarification of a couple things I found initially confusing. As an example:

    //Don't do this! 
    var file = 'myFile.txt'; // Executes First
    fs.readFile(file, function () {
      sys.write("Hi"); // Executes Third
    });
    sys.write("BYE") //Executes Second


This code will print out "BYE" before "HI". While initially counter-intuitive,
you can actually leverage this to make more readable code. Below is an example
from [my fork of node-paperboy](http://github.com/andrewvc
/node-paperboy). As you can see, #deliver returns a delegate, which lets us
set up our callbacks. [See this example](https://gist.github.com/358221#file_paperboy_delegate_example.js) for more.

<script src="https://gist.github.com/358221.js?file=PaperboyDelegateExample.js"></script>    

The interesting part about this is that after all our delegates are setup
there's no need to call a method to says we're done adding methods to the
delegate, and that its free to run and deliver the file. Looking at the
implementation of #deliver we can get a little more information about how this
works.

<script src="https://gist.github.com/358229.js?file=node_delegate_example.js"></script>    

That's an incomplete portion of #deliver, a good chunk of it has been omitted
for brevity, the most important part here is process.nextTick, everything
within the anonymous function nextTick uses gets deferred until the next tick
of the clock, somewhat similarly (though more efficiently) than
`setTimeout(function() {}, 0);` . This allows us to return
our delegate after this has been setup, to allow the user to set the callbacks
via method calls on the delegate object. In this example, after the anonymous
function passed to http.createServer is done executing will the next tick
occur.

An important thing to remember is that you often don't need nextTick if you're
performing operations that are guaranteed to run on the next tick. Anything
wrapped inside an async request like fs.stat or an http.Client request will
end up running on the next tick. The only reason that process.nextTick was
explicitly required here was due to the synchronous check `if (fpErr) {...}`,
the rest of the code runs wrapped inside of fs.stat, which is an async call.

Node events are in some ways similar to delegates in how they're defined, if
you're interested, I recommend taking a look at the implementation
for [streamFile](http://github.com/andrewvc/node-
paperboy/blob/5189eed907feda959f92cd6837b0ba038545ddd8/lib/paperboy.js#L11),
as an example of how these are used.

Coding with node can be twisted (pun intended) but if you need the benefits an
evented framework provides and you work with, not against, it isn't half bad.

