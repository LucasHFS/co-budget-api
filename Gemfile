source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'rspec-rails', '~> 6.0.0'
  gem 'faker', '~> 3.1.0'
  gem 'simplecov', '~> 0.22.0'
  gem 'rubocop-performance', '~> 1.14'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '~> 2.11'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda-matchers', '~> 5.3'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

gem 'devise', '~> 4.8'
gem 'devise-jwt', '~> 0.10.0'
gem 'pry', '~> 0.14.2'
gem 'jbuilder', '~> 2.11'
gem 'state_machine', '~> 1.2'

gem 'dotenv-rails', '~> 2.8'


gem "activerecord-import", "~> 1.5"

gem "sentry-ruby", "~> 5.12"
gem "sentry-rails", "~> 5.12"
gem "rack-timeout", "~> 0.6.3"
