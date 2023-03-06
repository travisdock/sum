class CreateRecurrables < ActiveRecord::Migration[7.0]
  def change
    create_table :recurrables do |t|
      t.string :name
      t.text :rule
      t.decimal :amount
      t.string :notes
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: true, foreign_key: true

      t.timestamps
    end
  end
end
