---
permalink: cleaned-up-dripdrop-syntax
layout: post
tags : [ruby]
---


I finally found the time to make some important small changes to DripDrop. I cleaned up the syntax quite a bit using instance_eval. The main style differences are as follows:

<script src="https://gist.github.com/616962.js?file=dripdropdifferences.rb"></script>

I'm finally adding specs to it (Bad... I know). Writing specs for ZeroMQ isn't necessarily easy due to the fact that some sockets like pub/sub, while working fine in practice, don't exhibit the 'perfect' behavior your test framework wants. Shouldn't be too bad for the other socket types though.
