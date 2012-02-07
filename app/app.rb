load File.join(File.dirname(__FILE__), 'models.rb')

class BlagApp < Sinatra::Application
  ROOT = Pathname.new(__FILE__).dirname.parent

  set :views, ROOT.join('templates')

  get '/posts/:name' do |name|
    @content = Content.find("posts/#{name}")
    haml :post
  end
end
