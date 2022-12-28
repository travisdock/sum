class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :category

  scope :by_year, -> (year) { where('extract(year from date) = ?', year) }
end
