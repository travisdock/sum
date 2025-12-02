class AddVoiceEntriesEnabledToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :voice_entries_enabled, :boolean, default: false, null: false
  end
end
