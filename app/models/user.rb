class User < ApplicationRecord
  has_secure_password
  
  # Associations
  has_and_belongs_to_many :categories
  has_many :entries
  has_many :recurrables
  
  # Callbacks
  before_destroy :remove_data
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true
  
  # Normalize email before saving
  before_save :downcase_email
  
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
  
  # Remember me functionality
  def remember_me!
    self.remember_created_at = Time.current
    save!(validate: false)
  end
  
  def forget_me!
    self.remember_created_at = nil
    save!(validate: false)
  end
  
  def remember_me?
    remember_created_at.present? && remember_created_at > 1.month.ago
  end
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
end