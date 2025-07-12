class MigrateFromDeviseToVanillaAuth < ActiveRecord::Migration[8.0]
  def change
    # Rename encrypted_password to password_digest for has_secure_password
    rename_column :users, :encrypted_password, :password_digest
    rename_column :users, :email, :email_address

    # Remove Devise-specific columns we won't need
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
  end
end
