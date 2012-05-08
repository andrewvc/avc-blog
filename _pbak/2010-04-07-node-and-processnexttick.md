---
layout: post
category: 
tags : 
---


# Node and process.nextTick

Coding in Node, or any evented setting, often requires different ways of
thinking.&nbsp_place_holder;The primary difference being that you have to keep
track of&nbsp_place_holder;_when_&nbsp_place_holder;the code you're writing
will run. I've really just started writing code in Node, below is a
clarification of a couple things I found initially confusing. As an example:

    
    1
    2
    3
    4
    5
    6
    

//Don't do this!

var file = 'myFile.txt'; // Executes First

fs.readFile(file, function () {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;sys.write("Hi"); //
Executes Third

});

sys.write("BYE") //Executes Second

This code will print out "BYE" before "HI". While initially counter-intuitive,
you can actually leverage this to make more readable code. Below is an example
from&nbsp_place_holder;[my fork of node-paperboy](http://github.com/andrewvc
/node-paperboy). As you can see, #deliver returns a delegate, which lets us
set up our callbacks.

    
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
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    

http.createServer(function(req, res) {

&nbsp_place_holder;&nbsp_place_holder;var ip = req.connection.remoteAddress;

&nbsp_place_holder;&nbsp_place_holder;paperboy

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.d
eliver(WEBROOT, req, res)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.a
ddHeader('Expires', 300)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.a
ddHeader('X-PaperRoute', 'Node')

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.b
efore(function() {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;sys.log('Recieved Request')

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;})

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.a
fter(function(statCode) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;res.write('Delivered: '+req.url);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;log(statCode, req.url, ip);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;})

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.e
rror(function(statCode,msg) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;res.writeHead(statCode, {'Content-Type':
'text/plain'});

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;res.write("Error: " + statCode);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;res.close();

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;log(statCode, req.url, ip, msg);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;})

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;.o
therwise(function(err) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;var statCode = 404;

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;res.writeHead(statCode, {'Content-Type':
'text/plain'});

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;log(statCode, req.url, ip, err);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;})
;

}).listen(PORT);

The interesting part about this is that after all our delegates are setup
there's no need to call a method to says we're done adding methods to the
delegate, and that its free to run and deliver the file. Looking at the
implementation of #deliver we can get a little more information about how this
works:

    
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
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    

exports.deliver = function (webroot, req, res) {

&nbsp_place_holder;&nbsp_place_holder;var

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;st
ream,

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;fp
Res = exports.filepath(webroot, url.parse(req.url).pathname),

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;fp
Err = fpRes[0],

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;fi
lepath = fpRes[1],

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;er
rorCallback,

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;he
aderFields = {},

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;ad
dHeaderCallback,

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;de
legate = {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;error: function (callback) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;erro
rCallback = callback;

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;retu
rn delegate;

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;},

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;//...Setup the other callbacks...

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;};

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;

&nbsp_place_holder;&nbsp_place_holder;process.nextTick(function() {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;//
If file is in a directory outside of the webroot, deny the request

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;if
(fpErr) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;//... omitted for brevity...

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;}

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;el
se {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;fs.stat(filepath, function (err, stat) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;if(
(err || !stat.isFile())) {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;var exactErr = err || 'File not found';

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;if (beforeCallback)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;before
Callback();

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;if (otherwiseCallback)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;otherw
iseCallback(exactErr);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;}
else {

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;stream = exports.streamFile(filepath,
headerFields, stat, res, req)

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;//... omitted for brevity ...

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;if(errorCallback){

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;stream
.addListener("error", errorCallback);

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbs
p_place_holder;&nbsp_place_holder;}

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;}

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&n
bsp_place_holder;&nbsp_place_holder;});

&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;&nbsp_place_holder;}

&nbsp_place_holder;&nbsp_place_holder;});

&nbsp_place_holder;&nbsp_place_holder;

&nbsp_place_holder;&nbsp_place_holder;return delegate;

};

That's an incomplete portion of #deliver, a good chunk of it has been omitted
for brevity, the most important part here is process.nextTick, everything
within the anonymous function nextTick uses gets deferred until the next tick
of the clock, somewhat similarly (though more efficiently) than
`setTimeout(function() {}, 0);` .&nbsp_place_holder;This allows us to return
our delegate after this has been setup, to allow the user to set the callbacks
via method calls on the delegate object. In this example, after the anonymous
function passed to http.createServer is done executing will the next tick
occur.

An important thing to remember is that you often don't need nextTick if you're
performing operations that are guaranteed to run on the next tick. Anything
wrapped inside an async request like fs.stat or an http.Client request will
end up running on the next tick. The only reason that process.nextTick was
explicitly required here was due to the synchronous check `if (fpErr) {...}`,
the rest of the code runs wrapped inside of fs.stat, which is an async call.

Node events are in some ways similar to delegates in how they're defined, if
you're interested, I recommend taking a look at the implementation
for&nbsp_place_holder;[streamFile](http://github.com/andrewvc/node-
paperboy/blob/5189eed907feda959f92cd6837b0ba038545ddd8/lib/paperboy.js#L11),
as an example of how these are used.

Coding with node can be twisted (pun intended) but if you need the benefits an
evented framework provides and you work with, not against, it isn't half bad.

