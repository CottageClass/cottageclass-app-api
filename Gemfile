git_source(:github) { |repo| format 'https://github.com/%s.git', repo }

ruby '2.5.3'
source 'https://rubygems.org'

gem 'activeadmin', github: 'activeadmin/activeadmin', ref: '9292dfb548b7779db962ab7992ea4b1342ea69d4'
gem 'activeadmin_addons'
gem 'addressable'
gem 'devise-jwt'
gem 'fast_jsonapi'
gem 'geocoder'
gem 'inherited_resources', github: 'activeadmin/inherited_resources', ref: 'db6eb312b7cac6baf0023f720cf6785a9849fa85'
gem 'koala'
gem 'omniauth-facebook'
gem 'pg'
gem 'phony'
gem 'puma_worker_killer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'sendgrid-ruby'
gem 'timezone'
gem 'twilio-ruby', '~> 5.15.2'

gem 'apitome'
gem 'bcrypt', '~> 3.1.7'
gem 'country_select'
gem 'kaminari'
gem 'sassc-rails'
gem 'webpacker', '~> 4.0', '>= 4.0.2'

group :production do
  gem 'airbrake'
  gem 'airbrake-ruby'
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'puma-heroku'
  gem 'rails_12factor'
  gem 'uglifier'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'byebug'
  gem 'climate_control'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 4.1'
  gem 'faker'
  gem 'fakerbot', require: false
  gem 'guard-rspec', require: false
  gem 'httplog'
  gem 'mry', require: false
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
  gem 'therubyracer', platforms: :ruby
  gem 'timecop'
  gem 'webmock'
end
