---
permalink: why-arent-you-using-messagepack
layout: post
category: 
tags : [random]
title: Why Not MessagePack?
---

JSON is a fantastic format, anywhere people in your organization want to reach
for XML, it's always a good thing to ask the question "Why not JSON?". The
question I'd like you to ask the next time you're reaching for your JSON
hammer, is "Why not MessagePack?". 

[MessagePack](http://msgpack.org/) has the following things going for it when
compared to JSON.

  1. **JSON Compatible**: Anything that works with JSON will work with MessagePack.
  2. **More space efficient**: MessagePack uses an extremely efficient binary serialization format, for things like numbers and binary data MessagePack can be hugely more efficient. For use in persisting datastructures in something like Redis, where you want to be careful with memory usage, this is quite useful
  3. **Faster**: MessagePack is usually much faster to encode / decode than JSON.
  4. **Supports Your Language**: Ruby, Python, Perl, Javascript, PHP, Java, C++, C#,Go, Erlang, Haskell, OCaml, Scala, Clojure, and more all support MessagePack.
  5. **RPC**: There's a separate MessagePack RPC project that maintains a high performance MessagePack based RPC server and client available in most of the languages above.

For the record, I'd probably still use JSON for a public facing API in most
cases, but for internal ones, MessagePack generally wins.

The following example, written in Ruby, illustrates the advantages of
MessagePack in action:

<script src="https://gist.github.com/984879.js?file=messagepack_vs_json.rb"></script>    

*So, use MessagePack!*

For more info, check out the [Message Pack Website](http://msgpack.org/).

