source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0"

gem "solid_queue", "~> 1.1"
gem "mission_control-jobs"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
#gem "sprockets-rails"
gem "propshaft"

# Use sqlite3 as the database for Active Record
gem "sqlite3"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
#gem "jbuilder"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use devise for auth
gem 'devise'
gem "responders"

# Use Haml instead of erb
gem 'haml-rails'

# Use icecube for scheduling
gem 'ice_cube', github: 'ice-cube-ruby/ice_cube',
      ref: '6b97e77c106cd6662cb7292a5f59b01e4ccaedc6'

# Use ransack for search and sorting of tables
gem 'ransack'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # Use rpsec for testing
  gem 'rspec-rails'
  # Use SimpleCov for test coverage
  gem 'simplecov', require: false
  # Use database_cleaner for cleaning test database with Cypress
  gem 'database_cleaner'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :production do
  # Use Honeybadger for errors
  gem "honeybadger"
end
