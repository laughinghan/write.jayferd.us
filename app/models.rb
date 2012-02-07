require 'rubygems'
require 'bundler'
Bundler.require

require 'pathname'

module PathnameExtension
  def path_without_ext(rel=nil)
    path = self
    path = path.relative_path_from(rel) if rel

    path.to_s[0...-path.extname.size]
  end
end

Pathname.send(:include, PathnameExtension)

class Content
  ROOT = Pathname.new(__FILE__).dirname.parent.join('content')

  include Wrappable

  wraps :file

  def self.find(key)
    paths = []
    ROOT.find do |path|
      paths << path if path.path_without_ext(ROOT) == key
    end

    wrap(paths.first) if paths.any?
  end

  def self.ls(dir)
    ROOT.join(dir).children.map &method(:wrap)
  end

  def initialize(fname)
    super(Pathname.new(fname))
  end

  def source
    @source ||= file.open('r:UTF-8', &:read)
  end

  def content
    parsed[:content]
  end

  def metadata
    parsed[:metadata]
  end

  def [](k)
    metadata[k.to_s]
  end

  def html
    Renderer.html(content, format)
  end

  def format
    file.extname
  end

  def interpolate(context={})
    Renderer.interpolate(html, context)
  end

  def key
    @key ||= file.path_without_ext(ROOT)
  end

  def render(context={})
    {
      key: key,
      metadata: metadata,
      content: interpolate(context),
    }
  end

private
  # read the YAML frontmatter
  # regex stolen from Jekyll
  def parsed
    return @parsed if instance_variable_defined? :@parsed

    if source =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      { metadata: YAML.load($1), content: $' }
    else
      { metadata: {}, content: source }
    end
  end
end

module Renderer
  extend self

  class HTML < Redcarpet::Render::HTML
    # magical smart-quotes
    include Redcarpet::Render::SmartyPants

    def block_code(code, language)
      "<code>#{highlight_code(code, language)}</code>"
    end

  private
    def highlight_code(code, language=nil)
      return "<pre>#{code}</pre>" unless language
      Pygments.highlight(code, :lexer => language)
    end
  end

  def html(source, format)
    case format
    when '.txt', '.html'
      source
    when '.md', '.mkd'
      markdown.render(source)
    when '.yml', '.yaml'
      ''
    else
      '(( UNRECOGNIZED FORMAT ))'
    end
  end

  def interpolate(html, context={})
    Mustache.render(html, context)
  end

private
  def markdown
    @markdown ||= Redcarpet::Markdown.new(html_renderer,
      fenced_code_blocks: true
    )
  end

  def html_renderer
    @html_renderer ||= HTML.new
  end
end
