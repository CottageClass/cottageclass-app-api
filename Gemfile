git_source(:github) { |repo| format 'https://github.com/%s.git', repo }

ruby '2.5.3'
source 'https://rubygems.org'

gem 'activeadmin', github: 'activeadmin/activeadmin', ref: '9292dfb548b7779db962ab7992ea4b1342ea69d4'
gem 'activeadmin_addons'
gem 'activeadmin_json_editor'
gem 'addressable'
gem 'ahoy_matey'
gem 'awesome_print'
gem 'devise-jwt'
gem 'fast_jsonapi'
gem 'geocoder'
gem 'google_places'
gem 'inherited_resources', github: 'activeadmin/inherited_resources', ref: 'db6eb312b7cac6baf0023f720cf6785a9849fa85'
gem 'omniauth-facebook'
gem 'pg'
gem 'phony'
gem 'puma_worker_killer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'rpush'
gem 'sendgrid-ruby'
gem 'timezone'
gem 'twilio-ruby', '~> 5.15.2'

gem 'apitome'
gem 'bcrypt', '~> 3.1.7'
gem 'country_select'
gem 'kaminari'
gem 'meta-tags', '~> 2.11', '>= 2.11.1'
gem 'sassc-rails'
gem 'webpacker', '~> 4.0', '>= 4.0.2'

group :production, :staging do
  gem 'newrelic_rpm'
end

group :production do
  gem 'airbrake'
  gem 'airbrake-ruby'
  gem 'puma-heroku'
  gem 'uglifier'
end

group :development, :test, :staging do
  gem 'factory_bot_rails', '~> 4.1'
  gem 'faker'
  gem 'fakerbot', require: false
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'byebug'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'guard-rspec', require: false
  gem 'httplog'
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'ruby-prof'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'webmock'
end
