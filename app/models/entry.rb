class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :category

  scope :by_year, -> (year) { where('extract(year from date) = ?', year) if year.present? }
  scope :by_month, -> (month) { where('extract(month from date) = ?', month) unless month.blank? || month.to_i.zero? }
end
