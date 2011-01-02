--- 
title: Well, that was easy.
date: 01/01/2011

[toto]: http://cloudhead.io/toto
[pygments]: http://pygments.appspot.com/
[heroku]: http://heroku.com/

Well, I guess I have a blog now.  Hopefully I remember to write things in it sometime!

It was actually really super easy to get set up.
I'm using this awesome framework called [toto][], and deploying through [heroku][], which all took zero set-up time.

<!-- snip -->

Actually, the hardest part of this whole thing was getting syntax highlighting working.
Since heroku doesn't support pygments, I'm using the [unofficial api][pygments], which works like a charm.  Just POST there and specify 'lang' and 'code', and you get a nice little colorized html code snippet.

So I cooked up a hacky little bit of Hpricot and HTTParty magic to create a `colorize` filter through which I pass the body of my posts:

    @@ ruby

    module Colorize
      def colorize(body)
        doc = Hpricot(body)
        doc.search('pre').each do |pre|
          code = pre.children[0].inner_text

          lang, code = parse_lang(code)

          colorized = pygments_api(code, lang)

          pre.swap(colorized)
        end

        doc.to_html
      end

      PYGMENTS_API = 'http://pygments.appspot.com/'

      def pygments_api(code, lang=nil)
        return <<-html unless lang
          <div class="highlight"><pre>#{code}</pre></div>
        html

        HTTParty.post(PYGMENTS_API, :body => {
          :code => code,
          :lang => lang
        })
      end

      def parse_lang(code)
        return [nil, code] unless code.start_with? '@@'

        lines = code.split "\n"

        lines.shift =~ /@@\s*(\w+)/

        [:"#{$1}", lines.join("\n")]
      end
    end

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

This is awesome.  Let's see where it takes us.
