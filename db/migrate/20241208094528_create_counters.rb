class CreateCounters < ActiveRecord::Migration[8.0]
  def change
    create_table :counters do |t|
      t.integer :count, default: 0, null: false
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end
