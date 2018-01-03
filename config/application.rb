require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Christianrails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Atlantic Time (Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators do |g|
      g.template_engine :haml
      g.helper          false
      g.jbuilder        false
    end

    config.exceptions_app = self.routes

    config.action_view.logger = nil

    config.assets.paths << Rails.root.join("app", "assets", "stylesheets", "woods")

    ActiveSupport.halt_callback_chains_on_return_false = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000'
        resource '*',
          headers: :any,
          methods: [:get, :put],
          credentials: true,
          max_age: 0
      end
    end

    config.sync_token = ENV['SYNC_TOKEN']
  end
end
