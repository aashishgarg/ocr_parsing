source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'aasm' # For adding states
gem 'apipie-rails' # For API Documentation
gem 'aws-sdk-s3', '~> 1'     # AWS S3
gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'cancancan', '~> 2.0' # For Authorization
gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views
gem 'devise-jwt'             # Authentication
gem 'dotenv-rails', groups: [:development, :test] # Shim to load environment variables from .env into ENV in development
gem 'exception_notification' # For Error Email delivery with log trace
gem 'jbuilder', '~> 2.5'
gem 'kaminari'               # for pagination
gem 'paper_trail'            # Change Audit
gem 'paperclip', '~> 6.0.0'  # File Upload Operations
gem 'pg'                     # Use pg as the database for Active Record
gem 'puma', '~> 3.11'        # Use Puma as the app server
gem 'rails', '~> 5.2.2'
gem 'rack-cors', :require => 'rack/cors'
gem 'rolify'                 # For Roles implementation
gem 'sass-rails', '~> 5.0'   # Use SCSS for stylesheets
gem 'sidekiq', '~> 5.2'      # Backgound jobs
gem 'sidekiq-history', '~> 0.0.9' # For keeping Sidekiq history
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'   # Use Uglifier as compressor for JavaScript assets
gem 'sidekiq-failures'       # See details of failed jobs

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a
                                                      # debugger console
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'letter_opener'        # For opening any email delivery locally for development purpose
  gem 'pry'
  gem 'rspec-rails', '~> 3.8'# Unit testing Framework
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2' # Spring speeds up development by keeping your application running in the background.
                                    # Read more: https://github.com/rails/spring
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
  gem 'web-console', '>= 3.3.0' # Access an interactive console on exception pages or by calling 'console'
                                # anywhere in the code.
end

group :test do
  gem 'capybara', '>= 2.15'     # Adds support for Capybara system testing and selenium driver
  gem 'chromedriver-helper'     # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
