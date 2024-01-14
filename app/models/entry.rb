class Entry < ApplicationRecord
  include Taggable

  belongs_to :user
  belongs_to :category

  scope :by_year, -> (year) { where("strftime('%Y', date) = ?", year.to_s) if year.present? }
  scope :by_month, -> (month) { where("ltrim(strftime('%m', date), '0') = ?", month.to_s) unless month.blank? || month.to_i.zero? }
  scope :by_income, -> (income) { joins(:category).where(categories: { income: income }) if !!income == income }
  scope :by_untracked, -> (untracked) { joins(:category).where(categories: { untracked: untracked }) if !!untracked == untracked }
  scope :by_category_id, -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_tag_id, -> (tag_id) { where(tag_id: tag_id) if tag_id.present? }
end
