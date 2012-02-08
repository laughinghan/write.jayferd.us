load File.join(File.dirname(__FILE__), 'models.rb')

class BlagApp < Sinatra::Application
  ROOT = Pathname.new(__FILE__).dirname.parent

  def self.logger
    @logger ||= Logger.new('log/blag.log')
  end

  configure do
    set :root, ROOT
    set :views, ROOT.join('templates')
    set :haml, {:format => :html5, :escape_html => false}
    set :sass, {
      :style => :compact,
      :debug_info => false
    }
    Compass.add_project_configuration(ROOT.join('config', 'compass.rb'))
    Compass.configure_sass_plugin!

    enable :logging
  end

  get '/' do
    @posts = Content.ls('posts')
    haml :index
  end

  get '/posts/:name' do |name|
    @post = Content.find("posts/#{name}")
    haml :post
  end

  get '/pages/:name' do |name|
    @post = Content.find("pages/#{name}")
    haml :post
  end

  get '/css/:name.css' do |name|
    content_type "text/css", charset: 'utf-8'

    sass_file = "./assets/sass/#{name}.sass"
    Sass.compile_file(sass_file,
      load_paths: Compass.configuration.sass_load_paths
    )
  end
end
