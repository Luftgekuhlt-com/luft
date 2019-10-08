class CreateSyncLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :sync_logs do |t|
      t.text :additional_info, limit: 40000
      
      t.timestamps
    end
  end
end
