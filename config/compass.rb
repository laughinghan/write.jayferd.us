project_path = defined?(BlagApp) ? BlagApp.root : Pathname.new('.')
environment = ENV['RACK_ENV'] || :development
sass_dir = project_path.join('assets/sass')
cache_path = project_path.join('.sass-cache')
css_dir = project_path.join('public/css')
images_dir = project_path.join('public/images')
http_path = "/"
http_images_path = "/images"
http_stylesheets_path = "/css"
