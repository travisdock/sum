source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

gem 'puma'

gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'rails', '~> 8.0'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'mission_control-jobs'
gem 'solid_queue', '~> 1.1'

gem 'propshaft'

gem 'sqlite3'

gem 'bcrypt'

gem 'csv'

gem 'haml-rails'

# TODO: Dependency to remove
# Use ransack for search and sorting of tables
gem 'ransack'

group :development, :test do
  gem 'database_cleaner'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'simplecov', require: false
end

group :development do
  gem 'claude-on-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
end

group :production do
  gem 'honeybadger'
end
