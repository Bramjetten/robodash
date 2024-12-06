class CreateDashboards < ActiveRecord::Migration[8.0]
  def change
    create_table :dashboards do |t|
      t.string :name, null: false
      t.string :token, null: false

      t.index :token, unique: true

      t.timestamps
    end
  end
end
