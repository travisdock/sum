class AddTagRefToEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :entries, :tag, null: true, foreign_key: true
  end
end
