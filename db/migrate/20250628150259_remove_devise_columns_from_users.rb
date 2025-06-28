class RemoveDeviseColumnsFromUsers < ActiveRecord::Migration[7.2]
  def up
    # Remove Devise-specific columns since we've migrated to vanilla authentication
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    
    # Remove Devise indexes
    remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    
    puts "Removed Devise columns and indexes from users table"
  end

  def down
    # Restore Devise columns if needed
    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    
    # Restore indexes
    add_index :users, :reset_password_token, unique: true
    
    puts "Restored Devise columns and indexes to users table"
  end
end
