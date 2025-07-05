class MigrateFromDeviseToVanillaAuth < ActiveRecord::Migration[8.0]
  def change
    # Rename encrypted_password to password_digest for has_secure_password
    rename_column :users, :encrypted_password, :password_digest
    
    # Remove Devise-specific columns we won't need
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    
    # Keep remember_created_at for remember me functionality
    # Keep email with its unique index
  end
end