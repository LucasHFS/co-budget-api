# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |_repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'rails', '~> 7.1', '>= 7.1.3.3'

gem 'pg', '~> 1.1'
gem 'puma', '~> 6.4', '>= 6.4.2'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rack-cors'

group :development, :test do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.1.0'
  gem 'flog', '~> 4.8'
  gem 'pry', '~> 0.14.2'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop-performance', '~> 1.14'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '~> 2.11'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', '~> 0.22.0'
end

gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'devise-jwt', '~> 0.11.0'
gem 'jbuilder', '~> 2.12'
gem 'state_machine', '~> 1.2'

gem 'dotenv-rails', '~> 2.8'

gem 'activerecord-import', '~> 1.7'

gem 'rack-timeout', '~> 0.6.3'
gem 'sentry-rails', '~> 5.12'
gem 'sentry-ruby', '~> 5.12'

gem 'sidekiq', '~> 7.2'
gem 'sidekiq-scheduler', '~> 5.0'

gem "fakeredis", "~> 0.9.2"
gem "mock_redis", "~> 0.44.0"
