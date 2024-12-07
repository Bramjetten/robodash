class CreateWidgets < ActiveRecord::Migration[8.0]
  def change
    create_table :widgets do |t|
      t.references :dashboard, null: false, foreign_key: true
      t.references :widgetable, null: false, polymorphic: true
      t.string :name
      t.datetime :alerted_at

      t.index [:widgetable_type, :widgetable_id]
      t.index [:name, :dashboard_id, :widgetable_type], unique: true

      t.timestamps
    end

  end
end
