---
permalink: quickly-constantize
title: Quickly Constantize
layout: post
tags : [ruby]
---

Constantizing in ruby without rails isn't intuitive. This snippet I whipped up
does the trick though.

    "Net::HTTP".split('::').inject(Object) {|memo,name| memo = memo.const_get(name); memo}

