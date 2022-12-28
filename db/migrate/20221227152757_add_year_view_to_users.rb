class AddYearViewToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :year_view, :integer
  end
end
