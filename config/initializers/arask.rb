Arask.setup do |arask|
  arask.create script: 'Recurrable.create_occurrences', cron: '0 0 * * *' # At 12:00AM every day
end
