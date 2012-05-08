---
title: Using Masochism multiple DB support with Engine Yard Cloud
layout: post
category: 
tags : 
---




If you're using the [Engine Yard Cloud](http://www.engineyard.com/), and you
want to run in a single master, single slave MySQL setup you can accomplish
this pretty easily using
[Masochism](http://github.com/technoweenie/masochism). It's as easy as:

  1. `script/plugin install git://github.com/technoweenie/masochism.git`
  2. Create deploy/before_migrate.rb if you don't have it already, then add this line to it: `run "sed -ibak -e 's/^production:$/master_database:/; s/^slave:$/production:/' #{shared_path}/config/database.yml"`
  3. Add to environment.rb (within the Rails::Initializer.run block):   
`config.after_initialize do &nbsp_place_holder;&nbsp_place_holder;if
Rails.env.production? &nbsp_place_holder;&nbsp_place_holder;
&nbsp_place_holder;ActiveReload::ConnectionProxy::setup!
&nbsp_place_holder;&nbsp_place_holder;end end`

