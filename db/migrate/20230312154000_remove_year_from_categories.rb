class RemoveYearFromCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :categories, :year
  end
end
