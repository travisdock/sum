class CreateApiTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :api_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :token_digest, null: false
      t.integer :request_count, null: false, default: 0
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :api_tokens, :token_digest, unique: true
  end
end
