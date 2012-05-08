# Quickly Constantize

Constantizing in ruby without rails isn't intuitive. This snippet I whipped up
does the trick though.

    
    1
    

"Net::HTTP".split('::').inject(Object) {|memo,name| memo =
memo.const_get(name); memo}

