namespace :test do
  desc "Daily run to create recurring entries"
  task run: :environment do
    puts "You did it"
    Rails.logger.error "Running daily recurring entries"
  end
end
