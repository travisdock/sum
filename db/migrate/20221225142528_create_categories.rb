class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :income
      t.boolean :untracked
      t.integer :year

      t.timestamps
    end
  end
end
