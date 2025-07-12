class UpdateUsersForNewAuth < ActiveRecord::Migration[8.0]
  def change
    # Check if columns exist before attempting to modify them
    if column_exists?(:users, :email) && !column_exists?(:users, :email_address)
      rename_column :users, :email, :email_address
    end
    
    if column_exists?(:users, :remember_created_at)
      remove_column :users, :remember_created_at, :datetime
    end
  end
end
