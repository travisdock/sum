class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_and_belongs_to_many :categories
  has_many :entries
  has_many :recurrables
  before_destroy :remove_data

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true

  def tags
    # was going to use has_many through but it was not working
    tag_ids = entries.distinct.pluck(:tag_id)
    Tag.where(id: tag_ids)
  end

  def remove_data
    self.tags.destroy_all
    self.entries.destroy_all
    self.categories.destroy_all
  end
end
