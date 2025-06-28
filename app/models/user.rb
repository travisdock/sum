class User < ApplicationRecord
  # Vanilla authentication
  has_secure_password validations: false
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  has_and_belongs_to_many :categories
  has_many :entries
  has_many :recurrables
  before_destroy :remove_data
  before_save :downcase_email
  before_create :generate_session_token

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

  # Authentication methods
  def self.find_by_credentials(email, password)
    user = User.find_by(email: email.downcase)
    return nil unless user
    
    user.authenticate(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.current
    self.save!
  end

  def password_reset_expired?
    return true unless password_reset_sent_at
    password_reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
