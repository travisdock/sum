class DropAraskJobs < ActiveRecord::Migration[8.0]
  def change
    drop_table :arask_jobs
  end
end
