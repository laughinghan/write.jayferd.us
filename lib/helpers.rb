module Helpers
  def colorize(body)
    doc = Hpricot(body)
    doc.search('pre').each do |pre|
      code = pre.children[0].innerHTML

      style, code = grab_style(code)

      colorized = (
        style ? Albino.new(code, style) : Albino.new(code)
      ).colorize

      pre.swap(colorized)
    end

    doc.to_html
  end

  def grab_style(code)
    return [nil, code] unless code.start_with? '@@'


    lines = code.split "\n"

    lines.shift =~ /@@\s*(\w+)/

    [:"#{$1}", lines.join("\n")]
  end
end
