class RemoveYearViewFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :year_view
  end
end
