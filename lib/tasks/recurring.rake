namespace :recurring do
  desc "Daily run to create recurring entries"
  task run: :environment do
    Recurrable.where(day_of_month: Date.today.day).each do |recurrable|
      recurrable.create_occurrence
    end
  end

end
