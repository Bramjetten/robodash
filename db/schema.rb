# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_06_205544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dashboards", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_dashboards_on_token", unique: true
  end

  create_table "heartbeats", force: :cascade do |t|
    t.string "schedule_period", default: "day", null: false
    t.integer "schedule_number", default: 1, null: false
    t.integer "grace_period", default: 60, null: false
    t.datetime "pinged_at"
    t.datetime "alerted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "widgets", force: :cascade do |t|
    t.bigint "dashboard_id", null: false
    t.string "widgetable_type", null: false
    t.bigint "widgetable_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_widgets_on_dashboard_id"
    t.index ["name", "dashboard_id", "widgetable_type"], name: "index_widgets_on_name_and_dashboard_id_and_widgetable_type", unique: true
    t.index ["widgetable_type", "widgetable_id"], name: "index_widgets_on_widgetable"
    t.index ["widgetable_type", "widgetable_id"], name: "index_widgets_on_widgetable_type_and_widgetable_id"
  end

  add_foreign_key "widgets", "dashboards"
end
