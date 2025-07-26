class Recurrable < ApplicationRecord
  include Taggable

  belongs_to :category
  belongs_to :user

  def self.create_occurrences
    where(day_of_month: Date.today.day).each do |recurrable|
      unless Entry.where(user_id: recurrable.user_id, category_id: recurrable.category_id, date: Date.today,
                         amount: recurrable.amount, notes: recurrable.notes).exists?
        recurrable.create_occurrence
      end
    end
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
