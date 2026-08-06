class RemoveVoiceEntriesEnabledFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :voice_entries_enabled, :boolean, default: false, null: false
  end
end
