class AddMeasurements < ActiveRecord::Migration[8.0]
  def change
    create_table :measurements do |t|
      t.string :unit
      t.timestamps
    end

    create_table :samples do |t|
      t.references :measurement, null: false, foreign_key: true
      t.integer :value, default: 0, null: false
      t.datetime :timestamp
    end
  end
end
