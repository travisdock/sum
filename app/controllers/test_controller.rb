class TestController < ApplicationController
  def clear_db
    if Rails.configuration.database_configuration[Rails.env]['database'] == 'storage/test.sqlite3'
      DatabaseCleaner.clean_with(:truncation)
      render plain: 'Database cleaned'
    else
      render plain: 'Database not cleaned. Not using test database.'
    end
  end
end
