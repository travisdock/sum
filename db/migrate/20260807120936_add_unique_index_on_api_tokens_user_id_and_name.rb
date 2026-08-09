class AddUniqueIndexOnApiTokensUserIdAndName < ActiveRecord::Migration[8.1]
  def change
    add_index :api_tokens, %i[user_id name], unique: true
  end
end
