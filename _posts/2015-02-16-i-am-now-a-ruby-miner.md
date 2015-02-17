---
permalink: i-am-now-a-ruby-miner
title: Now, I am a Ruby Miner
layout: post
tags: ['ruby', 'programming']
---

I've recently made a big move. As a 7 year long ViM and Emacs user, switching to a new text editor
feels akin to switching to a new religion. So, I was especially surprised to find myself falling for a big fat honking IDE, [Ruby Mine](https://www.jetbrains.com/ruby/), over the past few months. 
In the past I'd dismissed it as bloated and clunky. However, when we started getting serious about Typescript at <a href="http://pareto.com">Pareto</a>, I thought I should give it a try. 
I was surprised to find myself switching my whole ruby environment over to it.
It's been a dream as far as both Ruby and Typescript/Javascript dev. I'd like to explore why.

Throughout my time in the software industry, I've tried many editors, though for most of
my career ViM and Emacs have been my tools of choice. Sure, there were many before them,
[jedit](http://www.jedit.org/), [gedit](https://wiki.gnome.org/Apps/Gedit), [Kate](http://kate-editor.org/), [notepad++](http://notepad-plus-plus.org/), [dreamweaver](http://www.adobe.com/products/dreamweaver.html), [ultraedit](http://www.ultraedit.com/), [bbedit](http://www.barebones.com/products/bbedit/), [atom](https://atom.io/), [Allaire HomeSite](http://en.wikipedia.org/wiki/Macromedia_HomeSite), Rad Rails, and probably whole bunch I've now
forgotten about. 

ViM and Emacs seemed like perfection once I actually learned their arcane ways and spent a week setting up my configs. I used ViM for years when I worked
mostly as a Systems Administrator and Rails developer, switching to Emacs when I wanted 
better Clojure support back in the early days of Clojure. At some point this year I got sick
of Emacs for OSX causing my CPU to spin once again. I decided to try out a bunch of new editors.
I spent a while stuck on Github's new [Atom](https://atom.io/) editor. I liked its UI, but hated its instability. 

Salvation was found with Ruby Mine.

I've sat down and compiled a list of pros and cons I've experienced with Ruby Mine. On balance,
I'm very happy with it, I hope others find this useful :).

*Pros*

* An amazing debugger.
* Full Emacs key binding support, easily customizable to my needs.
* Great Javascript/Typescript support. Typescript let's Ruby Mine do some awesome intelligent completion.
* No need to manage a bunch of confusing text configuration files. The defaults are pretty good. I did have to mess with the emacs bindings to get them closer to a 'normal' Emacs setup. This was easily done in the GUI.
* Ruby Mine has one clear, high quality, way to do things. Emacs/ViM have a million open source packages in various stages of development, many abandoned with no notice.
* A sane window splitting/switching mechanism. I hate IDEs that assume you just want one pane most of the time!
* Ruby Mine uses the same base editor platform underlying IntelliJ, which I use for Java/Clojure (via [cursive](https://cursiveclojure.com/)), it's nice to stay in the same family.
* I love being able to just right click on a test I want to run or debug, click 'Debug <testname>' and have it do the right thing.
* Full JRuby support.
* Good Vagrant support.

*Cons*

* Need to edit a random python file? Nope, Rubymine is Ruby / JS / Shell only.
* Still a little laggy, even on my mid-2014 15" MBP w/ 16GB ram.
* Needs manual switch via text config to JDK8 on OSX to get retina support.
* Costs actual money, though with their startup program it was only $100.