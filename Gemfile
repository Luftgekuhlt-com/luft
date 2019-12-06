source 'https://rubygems.org'

gem 'rbnacl', '< 5.0', :require => false                                                                                                                                                                
gem 'rbnacl-libsodium', :require => false                                                                                                                                                               
gem 'bcrypt_pbkdf', '< 2.0', :require => false

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.3'
# Use Puma as the app server
gem 'puma', '3.12.2'
# Use SCSS for stylesheets
#gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer'
gem 'browser', '2.3.0'
gem "nokogiri"
gem "cocoon"
gem 'tinymce-rails'

gem 'devise'

gem 'simple_form'
gem 'materialize-sass'
gem 'materialize-form'
gem 'aws-sdk', '~> 2.3.0'
gem "paperclip", "~> 5.0.0"

gem 'rack-oauth2'
# ActiveRecord adapter for MySQL
gem 'mysql2'
gem 'ar-octopus'

gem 'elasticsearch', '>= 1.0.15'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'faraday_middleware-aws-signers-v4'
gem 'searchkick'
# pagination
gem 'kaminari'
gem 'httparty', '~> 0.13'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-tagsinput-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'seed_dump'

group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
    gem 'better_errors'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :production do
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
