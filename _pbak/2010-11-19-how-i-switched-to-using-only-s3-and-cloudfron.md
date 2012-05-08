---
layout: post
category: 
tags : 
---


# How I Host My Site Using Only S3, CloudFront, and a Few Small Tools

Last night I switched my personal website
[andrewvc.com](http://www.andrewvc.com)&nbsp_place_holder;over from Rackspace
cloud to AWS. Thanks to some new functionality in Amazon's CloudFront I was
able to eliminate having a proper server at all. It is now possible to host a
site using just S3 and CloudFront, no EC2 required!

Since my site's static, it's perfectly capable of being hosted using nothing
but S3 for asset storage and Cloud Front (CF) for content delivery. Doing so I
wound up saving money, and improving my site's load times as well.

If you're interested in implementing this yourself you'll need:

  * An empty S3 Bucket
  * A CF distribution for that bucket
  * A Default Root Object (DRO) for your CF distribution, this sets what gets served on requests for '/'
  * A method of automatically syncing content to your bucket
  * A method of expiring content in the CF distribution post-sync

CF is bit of a pain to get into shape, but once you get things automated it's
well worth it. Since I've already done a lot of the hard work, you can
probably get going by simply tweaking my scripts.

First, a quick intro to how S3 and CF work together: One could always host
content on S3, send traffic via HTTP using a big, ugly URL like:

&nbsp_place_holder;[http://s3-us-
west-1.amazonaws.com/andrewvc.com/index.html](http://s3-us-
west-1.amazonaws.com/andrewvc.com/index.html).

However, such URLs aren't suitable for a visitor facing page. CF lets you get
rid of the bucket name in the file path (the
[andrewvc.com](http://andrewvc.com) part in the URL above) and use your own
domain instead of s3-region.amazonaws.com. Basically, you can have your own
domain map to a specific S3 root. The names are mapped using DNS CNAMEs, and
can be easily set in the AWS web console for CF. One downside of CNAMEs is
that they only work on subdomains, so, I can't host
[http://andrewvc.com](http://andrewvc.com) on CF, only
[http://www.andrewvc.com](http://www.andrewvc.com). I'm currently using [no-
ip](http://www.no-ip.com) as &nbsp_place_holder;DNS host, and they provide an
HTTP redirect service for [http://andrewvc.com](http://andrewvc.com), sending
traffic there over to the www subdomain.

Once you have the CNAME pointing at your CF distribution, you'll want to set
the distribution's default root object, which will be your site's homepage.
This... isn't so straightforward. You can't use the AWS web console to do that
at the moment, however, a number of third party tools, including the free
[Cyberduck](http://cyberduck.ch/) on OSX make this easy. For more info on
doing this see Matt Gibson's blog post on [serving websites using the
DRO.](http://gothick.org.uk/2010/10/26/serving-websites-using-s3-and-
cloudfronts-default-root-object/)

Once you've gotten this far, things get easier. You'll probably want a script
that does something similar to the&nbsp_place_holder;[script](https://github.c
om/andrewvc/little_hat/blob/master/sync.rb)&nbsp_place_holder;I wrote, which:

  1. Generates the static files for my site
  2. Syncs the files to S3 (I used the command line tool&nbsp_place_holder;[s3cmd](http://s3tools.org/s3cmd)&nbsp_place_holder;).&nbsp_place_holder;
  3. Optionally invalidates the edge versions of the files at CF points of presence.

The last part is very important, as by default CF will hold on to cached files
at the edge for **24 hours, **which would pretty much ruin any site. However,
there are a couple things you can do about this. One, is setting a shorter
expire time on your files in S3. You'll notice that my script sets the Expires
header for an hour in the future. I chose an hour because CF will not cache
files for shorter durations.

With CF, you must invalidate each file separately. Since the photos on my site
never change, I only invalidate the HTML, JS, and CSS explicitly. One downside
here is that the purge takes some time, for 5-10 minutes after issuing an
invalidation I saw content flapping between states, so be forewarned that it's
not an atomic transition. However, for a rarely modified, and incrementally
updated site like mine it's not a significant issue.

Be warned that you can only have 3 simultaneous 'in progress' invalidation
requests (as I said before, they take time to run), and if you invalidate more
than 1000 objects a month you'll start getting charged for it (though it's a
tiny amount). For these reasons I made the cache invalidation optional, as for
most of my updates I'm only syncing new content.

**UPDATE: **I may have been testing the invalidation incorrectly, others haven't seen the issue I describe in the following paragraph.&nbsp_place_holder;As another warning, be careful with updates if you try this system. There are still some aspects of CF's caching behaviour I'm not sure of. It seems that CF will want to wait a full hour after its last invalidation before it'll do another one. That may be a result of me explicitly setting the Expires header, something I still need to test.&nbsp_place_holder; I'm not absolutely sure of this, but it seems to be the case that invalidations don't always invalidate immediately. If you aren't OK with this, then I'd say reserve CF for hosting assets only, and version asset changes using different URL paths .

And that's it! I have to say I find using only S3 + CF to be a rather elegant
solution, despite the few ungainly warts regarding invalidation. If you'd like
to see the full source for my site, including the S3 scripts, I have [the full
source for [www.andrewvc.com](http://www.andrewvc.com)](https://github.com/and
rewvc/little_hat) available on GitHub.

**EDIT: **To those who say this is impractical, you're generally correct, but you're missing the point.

For my own purposes this works fantastically. However, I'd never deploy a
system with this caching behavior on behalf of a client. The potential for an
embarassing (or costly) mistake is just too high. However, this is my personal
site and this is the kind of stuff I love doing, I love the idea of my site
being hosted on a high performance CDN with global points of presence. That's
awesome.&nbsp_place_holder;

