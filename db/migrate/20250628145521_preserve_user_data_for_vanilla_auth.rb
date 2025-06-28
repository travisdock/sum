class PreserveUserDataForVanillaAuth < ActiveRecord::Migration[7.2]
  def change
    # Add fields needed for vanilla authentication while preserving Devise compatibility temporarily
    add_column :users, :password_digest, :string
    add_column :users, :session_token, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
    
    # Add indexes for performance
    add_index :users, :session_token, unique: true
    add_index :users, :password_reset_token, unique: true
    
    # Temporarily keep Devise fields for migration period
    # We'll remove them in a later migration after confirming data integrity
  end
end
