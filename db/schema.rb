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

ActiveRecord::Schema[7.0].define(version: 2022_10_26_232625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string "zipcode"
    t.string "street"
    t.string "city"
    t.string "country_code"
    t.decimal "lat"
    t.decimal "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["zipcode"], name: "index_locations_on_zipcode"
  end

  create_table "metrics", force: :cascade do |t|
    t.integer "location_id"
    t.string "zipcode"
    t.decimal "temp"
    t.decimal "min"
    t.decimal "max"
    t.integer "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "dt_txt"
    t.boolean "from_cache"
    t.index ["location_id"], name: "index_metrics_on_location_id"
    t.index ["zipcode"], name: "index_metrics_on_zipcode"
  end

end
