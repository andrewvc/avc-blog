---
layout: post
category: 
tags : 
---


--- layout: post category : tags : [intro, beginner, jekyll, tutorial] url: big-cookies-and-nginx title: Big Cookies and nginx --- I've [submitted]("http://nginx.org/pipermail/nginx/2009-December/017350.html") the following to the nginx mailing list, after dealing with errors caused by this hard to dig up bug: What I'd like to propose is having requests with headers with single lines larger than large_client_header_buffers respond with a status of 414 rather than 400. Additionally, large_client_header_buffers should default to a larger value, double the platform's page size, to bring up it up to an 8k minimum to match the largest cookie size in a mainstream browser (IE 8) which maxes out at 5117 bytes by my calculations. 

