---
title: Sendgrid + Sendgrid Toolkit is pretty awesome
layout: post
category: 
tags : 
---

[Sendgrid](http://sendgrid.com/)'s a great way to send email from your app.
They provide statistics, reliable delivery, and a fantastic XML/JSON API. If
you're using Ruby, I recommend checkout out [Sendgrid
Toolkit](http://github.com/freerobby/sendgrid_toolkit), which I just found out
about.

Sendgrid Toolkit is pretty much a thin wrapper using jnunemaker's
[HTTParty](http://github.com/jnunemaker/httparty), which I haven't heard about
till now. HTTParty's a pretty cool way to painlessly create an interface to a
Web API.

Sendgrid Toolkit's use of HTTParty makes adding functionality very easy. I
added bounce retrieve and delete functionality by merely adding the small
number of lines seen in the code sample.

<script src="https://gist.github.com/477944.js?file=SendgridToolkitBounces.rb"></script>