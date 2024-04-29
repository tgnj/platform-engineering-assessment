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

ActiveRecord::Schema[7.1].define(version: 2024_04_29_215142) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.string "source"
    t.string "entity_identifier"
    t.datetime "sign_in_time"
    t.datetime "sign_out_time"
    t.string "site_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_identifier"], name: "index_attendances_on_entity_identifier"
    t.index ["sign_in_time"], name: "index_attendances_on_sign_in_time"
    t.index ["sign_out_time"], name: "index_attendances_on_sign_out_time"
    t.index ["site_identifier"], name: "index_attendances_on_site_identifier"
  end

  create_table "visitors", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", id: :string, force: :cascade do |t|
    t.datetime "visited_at", precision: nil, null: false
    t.string "visitor_id", null: false
    t.string "page_path", null: false
    t.index ["visited_at"], name: "index_visits_on_visited_at_DESC", order: :desc
  end

end
