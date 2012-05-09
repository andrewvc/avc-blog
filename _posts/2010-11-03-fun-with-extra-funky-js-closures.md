---
title: Fun with Extra Funky JS Closures
layout: post
category: 
tags : 
---




I was pleasantly surprised today to see that&nbsp_place_holder;[Wade Simmons
(wadey)](http://github.com/wadey)&nbsp_place_holder;had added sent me a pull
request for adding a package.json file to&nbsp_place_holder;[node-
streamlogger](http://github.com/andrewvc/node-streamlogger), a node.js logging
library I wrote earlier this year. I was glad because that must mean it still
works well, which is impressive to me given the fast rate of change in
node.js. I haven't really used node since then, and the code's lay dormant
since may. However, it's worked well in production, and is as feature complete
as I believe it will ever need to be, so there isn't much to change really
(I'm sure I'll eat those words later) (EDIT: looking back through the code,
there are some warts, but it works efficiently and well).

I actually quite liked writing node-streamlogger, it's extremely simple (only
152 lines, including whitespace) and has hooks into just about every piece of
it that's possible. It's also easily configurable. The only thing I don't
really like about it was that I never wrote specs for it... but I digress.

One thing I learned writing it, is [currying](http://www.dustindiaz.com
/javascript-curry/). I'll freely admit to having to ask a question about how
to do this in #javascript on freenode, and I owe those who answered my
question a debt of gratitude.

The code below is responsible for dynamically generating methods for logging.
While the simple route would have been to have a simple function that works
like "logger.logAtLevel('warn','message')" (and I do indeed provide this
function), it's much nicer to be able to say "logger.warn('message')". This
would generally be easy, just define a function for each level, but it had to
work with runtime customizable route names. The following code, extracted from
[lib/streamlogger.js](http://github.com/andrewvc/node-
streamlogger/blob/master/lib/streamlogger.js#L55) accomplishes this:

<script src="https://gist.github.com/983617.js?file=funkyclosure.js"></script>


It takes a minute to wrap your head around, but it's quite rewarding once you
do. One thing about it that is confusing, is that the name logLevel is both
the parameter to the outermost anonymous function, and the first argument
passed into it.

