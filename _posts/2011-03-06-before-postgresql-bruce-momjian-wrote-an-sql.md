---
title: Before PostgreSQL, Bruce Momjian wrote an SQL in Shell
layout: post
category: 
tags : 
---




Bruce Momjian is best known as a member of the PostgreSQL core team, what most
people don't know is that in the early '90s, before he was working on
Postgres, he wrote another SQL database.

And he wrote it in shell.

The result, [SHQL](http://momjian.us/download/) is a pretty damn cool piece of
software. I had an informal chat about it with Bruce a couple weeks ago at
SCALE, and just had to write about it. The source is definitely a fun browse
because not only is it a cool idea, it's the kind of software that belongs to
a specific time. Asking Bruce how he picked shell, he mentioned that it was a
language he knew, and that Perl just seemed like it was too heavy at the time.

What's immediately striking about SHQL is its completeness given its mere 760
SLOC. It supports,&nbsp_place_holder;CREATE, DELETE, DROP, INSERT, SELECT,
UPDATE, WHERE, PRINT, EDIT as commands, but has surprising completeness,
including UNION and DISTINCT. It even supports a rudimentary form of views,
through which you can do a basic sort of joining!

SHQL is not pure shell, it makes heavy use of both awk and grep. For instance,
updating a table involves filtering the entire table through awk, directing
the output to a tmp file, then replacing the current data file with the new
one.

The source is definitely a fun browse, I'd recommend you
[download](http://momjian.us/download/) the file, and check out the
[README](http://momjian.us/download/shql.1.3.README) and
[demo](http://momjian.us/download/shql.1.3.demo.shql) as well!

One install note, on my ubuntu system /bin/sh has a few issues with it, I'd
definitely use bash proper to run it. Also, be sure to mkdir -p
~/shql/MYDBNAME.

