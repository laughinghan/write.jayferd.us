module Helpers
  def colorize(body)
    doc = Hpricot(body)
    doc.search('pre').each do |pre|
      code = pre.children[0].innerHTML

      style, code = grab_style(code)

      colorized = pygments_api(code, style)

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

  def grab_style(code)
    return [nil, code] unless code.start_with? '@@'


    lines = code.split "\n"

    lines.shift =~ /@@\s*(\w+)/

    [:"#{$1}", lines.join("\n")]
  end
end
