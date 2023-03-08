class Recurrable < ApplicationRecord
  include Taggable
  belongs_to :category
  belongs_to :user

  serialize :schedule

  def date=(day)
    schedule = IceCube::Schedule.new(Date.today)
    schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_month(day.to_i)
    write_attribute(:date, day.to_i)
    write_attribute(:schedule, schedule.to_yaml)
    write_attribute(:schedule_string, schedule.to_s)
  end

  def schedule
    IceCube::Schedule.from_yaml(read_attribute(:schedule))
  end
end
