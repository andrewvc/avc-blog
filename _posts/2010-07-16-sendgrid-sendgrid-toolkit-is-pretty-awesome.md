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
    

module SendgridToolkit

&nbsp_place_holder;&nbsp_place_holder;class Bounces < AbstractSendgridClient

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;de
f retrieve(options = {})

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;options.each {|k,v| options[k] = 1 if
k.to_s == 'date' && v == true}

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;api_post('bounces','get',options)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;en
d

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;de
f delete(options = {})

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;response =
api_post('bounces','delete',options)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;raise BounceEmailDoesNotExist if
response['message'].include?('does not exist')

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;response

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;en
d

&nbsp_place_holder;&nbsp_place_holder;end

end

