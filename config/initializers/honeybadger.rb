Honeybadger.configure do |config|
  config.before_event do |event|
    begin
      event.as_json.to_json
    rescue SystemStackError => e
      Honeybadger.notify(e, context: { event_type: event.event_type })
      event.halt!
    end
  end
end
