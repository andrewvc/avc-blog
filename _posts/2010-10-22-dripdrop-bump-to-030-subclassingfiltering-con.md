---
permalink: dripdrop-bump-to-030-subclassingfiltering-con
title: "DripDrop bump to 0.3.0. Subclassing,Filtering, Consistency, and Specs"
layout: post
tags : [ruby]
---




Just released [DripDrop](http://github.com/andrewvc/dripdrop) v 0.3.0. The big
new features in this release are message [subclassing](http://github.com/andre
wvc/dripdrop/blob/master/example/subclass.rb) and pub/sub topic filtering,
both courtesy of John W. Higgins ([wishdev](http://github.com/wishdev)), who
did a phenomenal job engineering these features cleanly. The other major
change is a revamped argument order for xrep and http servers and clients.
These are more consistent with the web socket interface (message as first arg)
and really clean up the API.

Message subclassing is especially exciting because now you're able to send
messages with much richer behavior. The javascript API doesn't yet support
subclasses explicitly (they just come through as plain DD.Message objects),
but support should be forthcoming in the next release.

On top of all this, we now have more spec coverage! I'll admit the test
coverage hasn't been great, since it wasn't baked in, but we're adding it in
as we go, and when I have time, I'm trying to fill it in as well. Questions?
Comments? I'd love to hear them, either here, on github, or on twitter
@andrewvc .

PS.

My plans for [distributed workers](http://blog.andrewvc.com/next-steps-for-
dripdrop-zeromq-distributed-wo) in DripDrop are on hold till I feel the
reactor code is well spec'd. Additionally, I think a rails routes style DSL
for managing all your socket names in larger apps might be more important. Or
maybe it's a terrible idea, it's not quite a fully formed idea yet.

-- Andrew

