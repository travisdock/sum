class Recurrable < ApplicationRecord
  include Taggable
  belongs_to :category
  belongs_to :user

  serialize :schedule, coder: YAML

  def day_of_month=(num)
    schedule = IceCube::Schedule.new(Date.today)
    schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_month(num.to_i)
    write_attribute(:day_of_month, num.to_i)
    write_attribute(:schedule, schedule.to_yaml)
    write_attribute(:schedule_string, schedule.to_s)
  end

  def schedule
    IceCube::Schedule.from_yaml(read_attribute(:schedule))
  end

  def self.create_occurrences
    # Sentry cron mon checkin
    #check_in_id = Sentry.capture_check_in('sum-recurring', :in_progress)

    where(day_of_month: Date.today.day).each do |recurrable|
      unless Entry.where(user_id: recurrable.user_id, category_id: recurrable.category_id, date: Date.today, amount: recurrable.amount, notes: recurrable.notes).exists?
        recurrable.create_occurrence
      end
    end

    # Sentry cron mon checkin
    #Sentry.capture_check_in('sum-recurring', :ok, check_in_id: check_in_id)
  end

  def create_occurrence
    Entry.create!(
      date: Date.today,
      amount: amount,
      notes: notes,
      category_id: category_id,
      user_id: user_id,
      tag_id: tag_id
    )
  end
end
