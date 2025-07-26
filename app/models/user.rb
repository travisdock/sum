class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Associations
  has_and_belongs_to_many :categories
  has_many :entries
  has_many :recurrables

  # Callbacks
  before_destroy :remove_data

  # Validations
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

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

  def password_reset_token
    signed_id(purpose: :password_reset, expires_in: 15.minutes)
  end

  def self.find_by_password_reset_token!(token)
    find_signed!(token, purpose: :password_reset)
  end
end
