class CreateFavorites < ActiveRecord::Migration[8.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :widget, null: false, foreign_key: true

      t.timestamps

      t.index [ :user_id, :widget_id ], unique: true
    end
  end
end
