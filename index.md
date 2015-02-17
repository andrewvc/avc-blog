---
layout: page
title: My Blog. Mostly Code.
---
{% include JB/setup %}


<ul class="nav">
  {% assign pages_list = site.pages %}
  {% assign group = 'navigation' %}
  {% include JB/pages_list %}
</ul>

<div class="about">
<img id='self' src="/assets/images/self2.jpg">
<div class="about-text">
<p>
I'm Andrew Cholakian. I'm a Software Developer living in Minneapolis, MN, cofounder of <a href="http://pareto.com">Pareto, Inc</a>, where we build supply chain optimization software. I love hacking on open source software, most of which is up on <a href="http://www.github.com/andrewvc">my github account</a>. I also am pretty interested in photography, I've got my photos up in <a href="http://photos.andrewvc.com">here</a>.
</p>
<p>
If you'd like to drop me a line, email me at: <a href="mailto:andrew@andrewvc.com">andrew@andrewvc.com</a>.
</p>
<p>
If you use an RSS reader, you can <a href="/atom.xml"><img src="/assets/images/feed-icon.png"> subscribe to my feed.</a>
</p>
</div>
</div>

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
