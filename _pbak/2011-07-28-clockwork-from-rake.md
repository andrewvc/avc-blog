---
layout: post
category: 
tags : 
---


# Clockwork from Rake

Clockwork's an awesome gem, but using it via its funky wrapper I'm not so nuts
about. Here's how to use it from Rake.

    
    1
    2
    3
    4
    5
    6
    

task :clockwork => :environment do

&nbsp_place_holder;&nbsp_place_holder;Clockwork.every(10.seconds,
"events.update_viewers") {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;Re
sque.enqueue(ViewerCountWorker)

&nbsp_place_holder;&nbsp_place_holder;}

&nbsp_place_holder;&nbsp_place_holder;Clockwork.run

end

