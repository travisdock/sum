class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.date :date
      t.decimal :amount, precision: 8, scale: 2
      t.string :notes
      t.string :category_name
      t.boolean :income
      t.boolean :untracked
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
