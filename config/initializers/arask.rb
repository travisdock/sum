Arask.setup do |arask|
  arask.create task: 'recurring:run', cron: '0 2 * * *' # At 02:00AM every day
end
