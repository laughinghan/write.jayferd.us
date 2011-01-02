
require 'toto'
require 'hpricot'
require 'httparty'
require File.join(File.dirname(__FILE__), 'lib', 'helpers')

Toto::Site::Context.send(:include, Helpers)

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  # set :author,    ENV['USER']                               # blog author
  # set :title,     Dir.pwd.split('/').last                   # site title
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :title, 'Things I Remember to Write Down'
  set :author, 'Jay Adkisson'

  set :ext, 'md'

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }

  set :summary, {
    :delim => /^<!--\s*snip\s*-->/,
    :max => 1000
  }

  set :disqus, 'writedown'
end

run toto
