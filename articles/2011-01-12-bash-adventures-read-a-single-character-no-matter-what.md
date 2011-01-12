--- 
title: "Bash adventures: read a single character, even if it's a newline"
date: 12/01/2011

### tl;dr

    @@bash
    getc() {
      IFS= read -d"$(echo -e '\004')" -n1 "$@"
    }

    getc ch
    echo "$ch" # don't forget to quote it!

### the explanation

So it turns out that it's pretty difficult to read exactly one character from a stream.
From the manual for `read` (usually in `man builtins`):

    -n nchars
           read returns after reading nchars characters rather  than
           waiting  for a complete line of input, but honor a delim‐
           iter if fewer than nchars characters are read before  the
           delimiter.


The naive solution, then would be:

    @@bash
    getc() {
      read -n1 "$@"
    }

    cat <<EOF | while getc ch; do echo "[$ch]"; done
    one
    two
    three
    four
    EOF

The output from this is:

    [o]
    [n]
    [e]
    []
    [t]
    [w]
    [o]
    []
    [t]
    [h]
    [r]
    [e]
    [e]
    []
    [f]
    [o]
    [u]
    [r]
    []

Wait, what happened to the newlines -- why are they returning empty characters?  Well, it turns out there are two things going on here.  Again from the manual:

    The characters in the value of the IFS variable are used to split the line into words.

...and the newline is in the IFS.  So let's zero out `IFS`:

    @@bash
    getc() {
      IFS= read -n1 "$@"
    }

unfortunately, this outputs the same thing, but for a different reason.
Remember: `read -n nchars` will still "honor a delimiter if fewer than `nchars` characters are read before the delimiter".
And the default delimiter (specified with `-d delim`) is the newline.
So the next solution is to set the delimiter to something that you know you won't care about.
I decided to use an EOF, since we know that won't be in the stream until the end.  You get an EOF with:

    @@bash
    eof="$(echo -e '\004')"

Now our `getc` looks like:

    @@bash
    getc() {
      IFS= read -n1 -d"$(echo -e '\004')" "$@"
    }

Now we get a very different output:

    [o]
    [n]
    [e]
    [
    ]
    [t]
    [w]
    [o]
    [
    ]
    [t]
    [h]
    [r]
    [e]
    [e]
    [
    ]
    [f]
    [o]
    [u]
    [r]
    [
    ]
    
Our newlines are back!  Yay!
