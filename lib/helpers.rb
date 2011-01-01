module Helpers
  def colorize(body)
puts '========== DEBUG body ========='
puts body
puts '==========end debug body ======'
    doc = Hpricot(body)
    doc.search('pre').each do |pre|
      code = pre.children[0].innerHTML

puts "code"
puts code
puts '======== DEBUG pre ==========='
puts pre.to_html
puts '===== end DEBUG pre =========='

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

p :lines_pre => lines

    lines.shift =~ /@@\s*(\w+)/

p :lines => lines,
  :match => $1

    [:"#{$1}", lines.join("\n")]
  end
end
