source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.4"

gem "puma"

gem "rails", "~> 8.0"
gem "bootsnap", require: false
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "solid_queue", "~> 1.1"
gem "mission_control-jobs"

gem "propshaft"

gem "sqlite3"

gem 'bcrypt'

gem 'csv'

gem 'haml-rails'

# TODO: Dependency to remove
# Use icecube for scheduling
gem 'ice_cube', github: 'ice-cube-ruby/ice_cube',
      ref: '6b97e77c106cd6662cb7292a5f59b01e4ccaedc6'

# TODO: Dependency to remove
# Use ransack for search and sorting of tables
gem 'ransack'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'database_cleaner'
end

group :development do
  gem "web-console"
  gem 'claude-on-rails'
end

group :production do
  gem "honeybadger"
end
