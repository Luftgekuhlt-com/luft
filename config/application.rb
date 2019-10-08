require_relative 'boot'

require 'rails/all'
require 'base64'
require 'rack/oauth2'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

unless Rails.env.production?
Spring.watch "app/services/**"
end

module SDO
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    
    require 'conf'
    
    Conf.load('secrets.yml', 'config.yml')
    
  end
end