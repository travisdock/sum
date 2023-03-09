class Recurrable < ApplicationRecord
  include Taggable
  belongs_to :category
  belongs_to :user

  serialize :schedule

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
