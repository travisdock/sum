class ApiToken < ApplicationRecord
  TOKEN_PREFIX = 'sum_'
  MAX_TOKEN_GENERATION_ATTEMPTS = 5

  belongs_to :user

  before_validation :generate_token, on: :create

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :token_digest, presence: true, uniqueness: true

  attr_reader :plaintext_token

  def self.authenticate(raw_token)
    return nil if raw_token.blank?

    find_by(token_digest: digest(raw_token))&.tap(&:record_usage!)
  end

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def record_usage!
    self.class.update_counters(id, request_count: 1, touch: :last_used_at)
  end

  private

  def generate_token
    MAX_TOKEN_GENERATION_ATTEMPTS.times do
      @plaintext_token = "#{TOKEN_PREFIX}#{SecureRandom.hex(32)}"
      self.token_digest = self.class.digest(@plaintext_token)
      break unless self.class.exists?(token_digest: token_digest)
    end
  end
end
