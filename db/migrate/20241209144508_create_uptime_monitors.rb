class CreateUptimeMonitors < ActiveRecord::Migration[8.0]
  def change
    create_table :uptime_monitors do |t|
      t.string :url, null: false
      t.integer :response_time
      t.integer :response_code

      t.timestamps
    end
  end
end
