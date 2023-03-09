class CreateRecurrables < ActiveRecord::Migration[7.0]
  def change
    create_table :recurrables do |t|
      t.string :name
      t.integer :day_of_month
      t.text :schedule
      t.string :schedule_string
      t.decimal :amount, precision: 8, scale: 2
      t.string :notes
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: true, foreign_key: true

      t.timestamps
    end
  end
end
