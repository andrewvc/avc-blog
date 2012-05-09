---
title: "Experiences with Noir: Taking Clojure Web-Dev to the Next Level"
layout: post
category: 
tags : 
---




If you're interested in getting started with web development in Clojure
there's something wrong with you. It's an elegant, fun, infuriating, and
enlightening experience. I've spent some of my spare time in the past few
weeks building an abstract rock garden in HTML/Canvas backed by Clojure's
[Noir](http://webnoir.org/) framework at [rocksandsand.com](http://rocksandsan
d.com)&nbsp_place_holder;([source](https://github.com/andrewvc/rocksandsand)).

I'm really excited
by&nbsp_place_holder;[Noir](http://webnoir.org/)&nbsp_place_holder;as a
framework as it's the first Clojure framework that has a strong opinion about
a lot of the things that really matter to a productive web framework.

Let's dive in.

Noir's hello world is what you'd expect in a post-sinatra world:

Where noir really gets interesting is in the tools, convenience, and opinions
it brings.

Here's what you get when you first run `lein noir new`. Right here is Noir's
first distinction, there's a lein (clojure's main build tool) plugin that will
generate a bare-bones Noir app from scratch for you, much like `rails s`.

Noir actively tries to make a bunch of simple web development tasks easy. It's
easily the Clojure framework that has the most 'batteries' included. You get
things like automatic code-reloading on page refresh, built in lein commands
to start up a server in both production and dev mode, a preset folder
structure, and a few other such nice opinionated ways of doing things.

Moving on from there, you'll notice your `src` folder contains two folders
'models' and 'views'. Here's where you'll first notice one of Noir's greatest
departures from most other web frameworks. There are no controllers by default
(you can read the&nbsp_place_holder;[mailing list
thread](https://groups.google.com/d/msg/clj-noir/FxipsTEhVtM/l4zX_lY1J5UJ) on
why if interested). You wind up with combinations of controllers, views, and
routes that--while initially scary--are actually quite elegant. An example of
a more complex Noir view:

For a small app like Rocks and Sand, this sort of thing works well, it's more
reasonable than splitting such stuff across 3 separate files. Whether it
scales up to a large app however, is something I'm still on the fence about.

Views in Noir are not mandated to use any particular language, but
[Hiccup](https://github.com/weavejester/hiccup)&nbsp_place_holder;is by far
the most popular solution, and is one of my all time favorite template
languages. And it's nothing but clojure vectors and maps! Here's a quick
example:

Models in noir are simply straightforward Clojure namespaces, if you want to,
noir ships with a validations library you can use with it.

While my experience with Noir is obviously limited I have a list of praises
and recommendations for it:

  * Coupling of Routes -> Controllers -> Views is nice for small stuff, I'd probably decouple them more in a larger app. Luckily, if you really want, there's no reason you can't just do that by your own convention. Noir won't get in your way.
  * Models are really bare bones, but have a nice little validation library. Not as complete as Rails', but quite easily extended
  * WebSockets are more and more important these days. Tighter integration with [Aleph](https://groups.google.com/d/msg/clj-noir/FxipsTEhVtM/l4zX_lY1J5UJ)&nbsp_place_holder;(defsocket anyone?) would be great. A&nbsp_place_holder;clojure framework that supports building combination synchronous / asynchronous apps would be awesome. While this is possible, the sugar that Noir's brought to Compojure could be extended to Aleph.
  * The integrated util packages (S3, App Engine, Crypt, Etc.) are awkward and should be in separate jars.
  * The ecosystem is still immature.I can still get more functionality out of Rails per hour due to its great community. However, for side-projects I'll be using noir. Additionally, for data-heavy web-services (like a JSON only backend) something like Noir is great!
  * I wound up writing my own JSON based configuration package. Config files are part of every real web-app, and I think a good config package (preferably with deployment environment (prod/staging/dev) built in.

All in all Noir is exactly what Clojure's been needing to move to the next
level in the world of web-apps. It's a beautiful framework, with a few odd
opinions, but in generally it's a great way to get a small web-app off the
ground. I'd recommend getting started by checking out the [Noir
homepage](http://webnoir.org/), and maybe even diving into the
[source](https://github.com/andrewvc/rocksandsand)&nbsp_place_holder;my rock
garden app.

