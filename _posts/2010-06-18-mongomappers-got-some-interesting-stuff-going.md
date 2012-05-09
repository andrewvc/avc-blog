---
permalink: mongomappers-got-some-interesting-stuff-going
title: MongoMapper's got some interesting stuff going on
layout: post
tags : [databases, ruby]
---




I've been playing around a bit with MongoDB + Rails recently, and have been
trying to figure out whether to use Mongo Mapper or Mongoid. I was pretty
certain I wanted to use Mongoid last week, due to its excellent docs, but
after reading John Nunemaker's post about [Mongo Mapper 0.8
goodies](http://railstips.org/blog/archives/2010/06/16/mongomapper-08-goodies-
galore/) I think I may be switching back over to MongoMapper (luckily I
haven't done much yet).

One other thing MongoMapper has in its favor is
[mongrations](http://github.com/terrbear/mongrations). Yes, while MongoDB
doesn't need migrations like SQL does, you DO still need to account for things
when you say, need to convert all your distance measurements from miles to
feet, or start adding indexes, or just want to delete a field in old records
that's no longer needed.

