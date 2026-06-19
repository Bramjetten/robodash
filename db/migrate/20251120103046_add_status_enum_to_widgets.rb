class AddStatusEnumToWidgets < ActiveRecord::Migration[8.0]
  def change
    add_column :widgets, :status, :integer, default: 0, null: false
  end
end
