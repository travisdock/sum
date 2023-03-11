Arask.setup do |arask|
  arask.create script: 'Recurrable.create_occurrences', cron: '0 2 * * *' # At 02:00AM every day
end
