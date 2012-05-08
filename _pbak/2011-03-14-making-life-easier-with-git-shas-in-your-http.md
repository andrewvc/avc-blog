---
layout: post
category: 
tags : 
---


# Making life easier with GIT SHAs in your HTTP Headers

Do you know what code is running on your servers? Perhaps someone deployed
something in a weird way and circumvented your normal deploy-logging process.
Maybe you suspect an application server didn't actually restart. Maybe you
just want to know quickly because you're lazy.

My answer to this question has been adding the Git SHA of the currently
running code to the HTTP headers of my app. By doing this, figuring out what's
actually running is as simple as a:

` curl -I http://www.example.net | grep X-GitSHA`

Accomplishing this is pretty simple, first, you'll want to run and store the
output of:

` git rev-parse HEAD`

in whatever directory your deployed code runs in. This is the fastest, and
easiest way to determine the current SHA. In Rails this is easily done in an
initializer or application.rb using something like:

` GIT_SHA = `git rev-parse HEAD`.chomp`

Then, just make sure the constant gets inserted as a header. Again, in Rails
you could do this with a before_filter in
controllers/application_controller.rb

` headers['X-GitSHA'] = MyApp::Application::GIT_SHA `

And you're done! It should just work. Of course there's a million ways to
actually do this.

Now that you have this info you can see what code is different between what's
deployed and what's on say your master branch with a `git diff`:

`PROD_SHA=`curl -I http://www.example.net | grep X-GitSHA | cut -d':' -f2` git
diff $PROD_SHA...master`

Or, you can see what the difference is in terms of commits messages rather
than actual lines changed with `git show-branch`

&nbsp_place_holder;`PROD_SHA=`curl -I http://www.example.net | grep X-GitSHA |
cut -d':' -f2` git show-branch $PROD_SHA master`

Lastly, if you need the cache on a resource busted between deploys be it in
either HTTP or Memcached, having a GIT_SHA constant available in your app
makes it pretty easy to do. Note that this isn't great for a lot of situations
where a file may NOT have changed between deploys.

