class CreateHeartbeats < ActiveRecord::Migration[8.0]
  def change
    create_table :heartbeats do |t|
      t.string :schedule_period, null: false, default: "day"
      t.integer :schedule_number, null: false, default: 1
      t.integer :grace_period, null: false, default: 60
      t.datetime :pinged_at
      t.datetime :alerted_at

      t.timestamps
    end
  end
end
