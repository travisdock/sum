class Entry < ApplicationRecord
  # Add tags
  belongs_to :tag, optional: true
  accepts_nested_attributes_for :tag, reject_if: :all_blank, allow_destroy: true

  belongs_to :user
  belongs_to :category

  scope :by_year, -> (year) { where('extract(year from date) = ?', year) if year.present? }
  scope :by_month, -> (month) { where('extract(month from date) = ?', month) unless month.blank? || month.to_i.zero? }
  scope :by_income, -> (income) { joins(:category).where(categories: { income: income }) if !!income == income }
  scope :by_untracked, -> (untracked) { joins(:category).where(categories: { untracked: untracked }) }

  private

  def autosave_associated_records_for_tag
    return if tag.blank?

    if tag.new_record? && Tag.find_by(name: tag.name).nil?
      tag.save
      self.tag = tag
    elsif tag.marked_for_destruction?
      self.tag = nil
      self.save
    elsif tag.new_record? && Tag.find_by(name: tag.name).present?
      self.tag = Tag.find_by(name: tag.name)
    elsif tag.changed? && tag.name.blank?
      self.tag = nil
      self.save
    elsif tag.changed?
      self.tag = Tag.find_or_create_by(name: tag.name)
    end
  end
end
