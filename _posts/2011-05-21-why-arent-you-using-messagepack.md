---
layout: post
category: 
tags : 
title: Why Not MessagePack?
---

JSON is a fantastic format, anywhere people in your organization want to reach
for XML, it's always a good thing to ask the question "Why not JSON?". The
question I'd like you to ask the next time you're reaching for your JSON
hammer, is "Why not MessagePack?".&nbsp_place_holder;

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

    
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    



> mixed_data = {"id"=>18929882, "title"=>"Lorem Ipsum", "author"=>"Sit Dolor"}

# JSON stores the data in a reasonable amount of space...

> mixed_data.to_json.length

=> 58

# But messagepack does much better

> MessagePack.pack(mixed_data).length

=> 44

# That's a pretty big difference! But its even more efficient with numbers

> numerical_array = [1223, 2190, 1980092, 8932191892, 98321982189]

> numerical_array.to_json.length

=> 42

> MessagePack.pack(numerical_array).length

=> 30

# Both are pretty fast...

> Benchmark.measure { 2_000_000.times { mixed_data.to_json} }

&nbsp_place_holder;=> 12.550000 0.040000 12.590000 ( 12.567510)

# But message pack is faster...

Benchmark.measure { 2_000_000.times { MessagePack.pack(mixed_data)} }

&nbsp_place_holder;=> 3.250000 0.020000 3.270000 ( 3.253008)

# They're compatible as well...

> JSON.parse(mixed_data.to_json) ==
MessagePack.unpack(MessagePack.pack(mixed_data))

# So, use MessagePack!

For more info, check out the [Message Pack Website](http://msgpack.org/).

