---
permalink: interrotron-a-safe-lisp-for-ruby
title: "Interrotron: a Safe Little Lisp for Ruby"
layout: post
tags : [ruby]
---

Last weekend I banged out a tiny language, [Interrotron](https://github.com/andrewvc/interrotron), meant to be used as a safe, embedded language for Ruby apps. I wrote Interrotron to meet the criteria of wanting a language that would

* execute a small amount untrusted code operating on pre-defined variables
* be safe from malicious scripts
* interact with ruby types and functions in a simple manner
* be easily embedded in a Ruby app
* have as few dependencies as possible, and be as small as possibel.

What I wound up with is a tiny lisp weighing in at 230 lines of ruby code, with only one dependency (Hashie, a common ruby library). Additionally, you can inject your own functions and macros (written in ruby), as well as variables. Here's a short example:

    Interrotron.run("(doubler (+ my_val 2))", :doubler => proc {|a| a*2 }, :my_val => 5)
    => 14

The main reason for Interrotron's existence is that you can't safely `eval` a piece of ruby code that's been given to you by a user (even trusted ones). Even if you manage to sandbox the whole env (and as far as I know there aren't any particularly safe ways of doing this in Ruby), you risk a malicious person inserting a `while 1; 1 end` causing your app to spin into an infinite loop.

Interrotron's pretty safe, it can't do very much. No loops, no variables, no functions, and no access to any APIs that can perform IO. What it's meant for is analyzing criteria, stuff like business rules. The kind of thing you might use interrotron for would look like: `(and (> 2 customer_sales) (< 5 customer_orders))` where you don't want things that can run for unbounded amounts of times. It's great for allowing admin users for your app to to create things like market segments.

I may add functions, closures, and  loops to the language in the future, but I don't need them now. If I add those features they would have to work with the current operation counting scheme for constraining execution time.

A note about speed by the way. It goes without saying that Ruby isn't particularly fast. Interrotron, being written in Ruby, is dog-slow. However, it's not intended for apps to run a large amount of Interrotron code. In fact, if you have more than a handful of lines, you've probably screwed up. That aside, its safety, simplicity, and extensability make it pretty useful for sandboxing untrusted code.

For more info visit the [github page](https://github.com/andrewvc/interrotron).
