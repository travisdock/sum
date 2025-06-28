class MigrateDevisePasswordsToVanilla < ActiveRecord::Migration[7.2]
  def up
    # Copy Devise encrypted_password to password_digest for existing users
    # Since Devise already uses bcrypt, we can copy the encrypted passwords directly
    User.where.not(encrypted_password: [nil, '']).find_each do |user|
      # Devise's encrypted_password is already bcrypt compatible
      user.update_column(:password_digest, user.encrypted_password)
      
      # Generate session token if not present
      if user.session_token.blank?
        user.update_column(:session_token, SecureRandom.urlsafe_base64)
      end
    end
    
    puts "Successfully migrated #{User.where.not(password_digest: [nil, '']).count} user passwords to vanilla authentication"
  end

  def down
    # Clear password_digest and session_token fields
    User.update_all(password_digest: nil, session_token: nil)
    puts "Reverted password migration - cleared password_digest and session_token fields"
  end
end
