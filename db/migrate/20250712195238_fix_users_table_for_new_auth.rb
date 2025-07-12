class FixUsersTableForNewAuth < ActiveRecord::Migration[8.0]
  def change
    # The table is already partially migrated. Let's fix it.
    # Current columns: id, email, password_digest, remember_created_at, created_at, updated_at
    
    # Rename email to email_address if it still exists as email
    if column_exists?(:users, :email) && !column_exists?(:users, :email_address)
      rename_column :users, :email, :email_address
    end
    
    # Add email_address if it doesn't exist
    unless column_exists?(:users, :email_address)
      add_column :users, :email_address, :string
    end
    
    # Remove remember_created_at if it exists
    if column_exists?(:users, :remember_created_at)
      remove_column :users, :remember_created_at
    end
    
    # Remove any remaining Devise columns
    remove_column :users, :reset_password_token if column_exists?(:users, :reset_password_token)
    remove_column :users, :reset_password_sent_at if column_exists?(:users, :reset_password_sent_at)
    
    # Ensure password_digest exists
    unless column_exists?(:users, :password_digest)
      add_column :users, :password_digest, :string
    end
    
    # Make sure columns are NOT NULL
    change_column_null :users, :email_address, false
    change_column_null :users, :password_digest, false
    
    # Ensure proper index on email_address
    unless index_exists?(:users, :email_address)
      add_index :users, :email_address, unique: true
    end
    
    # Re-add foreign keys if they don't exist
    add_foreign_key :entries, :users unless foreign_key_exists?(:entries, :users)
    add_foreign_key :recurrables, :users unless foreign_key_exists?(:recurrables, :users)
  end
end