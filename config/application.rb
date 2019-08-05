require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CottageclassAppApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # CORS - allow requests from only our client domain
    config.middleware.use Rack::Cors do
      allow do
        origins 'https://localhost:8077',
                'https://app.cottageclass.com',
                'https://www.joinlilypad.com',
                'https://kidsclub-develop.herokuapp.com',
                'https://cottageclass-app-staging.herokuapp.com',
                'https://cottageclass-app.herokuapp.com',
                'https://192.168.1.4:8077',
                'https://192.168.1.12:3001',
                'https://twilio.com'

        resource '*',
                 headers: :any,
                 credentials: true,
                 expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
                 methods: %i[get post put delete options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.eager_load_paths << config.root.join('lib')

    config.generators do |g|
      g.helper false
      g.assets false
      g.stylesheets false
      g.test_framework :rspec, fixture: true, fixture_replacement: :factory_bot, helper_specs: false,
                               view_specs: false, routing_specs: false, controller_specs: false
      g.scaffold_controller :scaffold_controller
    end

    # set TimeZone
    config.time_zone = 'UTC'

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.i18n.available_locales = %w[en]

    # TODO: BEGIN Review block, needs to be cleaned up
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # add back Cookies and Flash for ActiveAdmin
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    # END Review block, needs to be cleaned up

    # enable gzip compression
    config.middleware.use Rack::Deflater

    config.x.noreply_email = format 'no-reply@%s', ENV.fetch('APP_HOST')
    config.x.reply_to_email = 'contact@joinlilypad.com'
    config.x.brand_name = 'joinlilypad.com'
  end
end
