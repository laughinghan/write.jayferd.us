require 'digest'

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

    code_fpath = "cache/#{Digest::MD5.hexdigest("#{lang}|#{code}")}"

    if File.exists? code_fpath
      File.read(code_fpath)
    else
      rendered = HTTParty.post(PYGMENTS_API, :body => {
        :code => code,
        :lang => lang
      })

      if File.writable? code_fpath
        File.open(code_fpath, "w") { |f| f.puts rendered }
      end

      rendered
    end
  end

  def parse_lang(code)
    return [nil, code] unless code.start_with? '@@'

    lines = code.split "\n"

    lines.shift =~ /@@\s*(\w+)/

    [:"#{$1}", lines.join("\n")]
  end
end
