class CreateReadingsAndStatusChanges < ActiveRecord::Migration[8.1]
  def change
    # History of a widget: uptime checks, heartbeat pings and counts
    create_table :readings do |t|
      t.references :widget, null: false, foreign_key: true, index: false
      # Response time (ms) for uptime monitors, count for counters
      t.integer :value
      # HTTP response code for uptime monitors
      t.integer :code
      t.datetime :created_at, null: false

      t.index [ :widget_id, :created_at ]
    end

    # When a widget went down and came back up
    create_table :status_changes do |t|
      t.references :widget, null: false, foreign_key: true, index: false
      t.string :status, null: false
      t.datetime :created_at, null: false

      t.index [ :widget_id, :created_at ]
    end
  end
end
