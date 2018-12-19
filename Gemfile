git_source(:github) { |repo| format 'https://github.com/%s.git', repo }

ruby '2.4.1'
source 'https://rubygems.org'

gem 'activeadmin', github: 'activeadmin/activeadmin', ref: '9292dfb548b7779db962ab7992ea4b1342ea69d4'
gem 'activeadmin_addons'
gem 'addressable'
gem 'fast_jsonapi'
gem 'inherited_resources', github: 'activeadmin/inherited_resources', ref: 'db6eb312b7cac6baf0023f720cf6785a9849fa85'
gem 'knock', github: 'ngty/knock', ref: '9e9416c3745fc5e8fa73bbb901b69729d45aef9b'
gem 'koala'
gem 'pg'
gem 'puma_worker_killer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'twilio-ruby', '~> 5.15.2'

gem 'apitome'
gem 'country_select'

group :production do
  gem 'lograge'
  gem 'puma-heroku'
  gem 'rails_12factor'
  gem 'uglifier'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'ffaker'
  gem 'mry', require: false
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
  gem 'therubyracer', platforms: :ruby
  gem 'webmock'
end
