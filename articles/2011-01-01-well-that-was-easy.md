--- 
title: Well, that was easy.
date: 01/01/2011

[toto]: http://cloudhead.io/toto
[pygments]: http://pygments.appspot.com/
[heroku]: http://heroku.com/

Well, I guess I have a blog now.  Hopefully I remember to write things in it sometime!

It was actually really super duper easy to get set up.
I'm using this awesome framework called [toto][], and deploying through [heroku][].

<!-- snip -->

Actually, the hardest part of this whole thing was getting syntax highlighting working.
Since heroku doesn't support pygments, I'm using the [unofficial api][pygments], which works like a charm.

For reference, here's what that first post looks like in markdown:

    title: Mah First Post
    author: Jay Adkisson
    date: 2010/12/30

    It's my first post, everyone!  Here's some code to prove it:

        @@ ruby

        puts "Hello, world!"

    and how about this:

        @@ bash
        foo=BAR
        baz() {
          echo LOL #omg
        }

This is awesome.
