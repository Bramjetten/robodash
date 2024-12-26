class AddAccountReferenceToDashboards < ActiveRecord::Migration[8.0]
  def change
    add_reference :dashboards, :account, null: false, foreign_key: true
  end
end