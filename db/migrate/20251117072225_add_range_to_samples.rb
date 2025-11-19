class AddRangeToSamples < ActiveRecord::Migration[8.0]
  def change
    change_table :samples do |t|
      t.integer :min
      t.integer :max
    end
  end
end
