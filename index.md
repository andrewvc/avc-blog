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

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>