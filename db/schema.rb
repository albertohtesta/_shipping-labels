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

ActiveRecord::Schema.define(version: 2022_01_29_180403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carriers", force: :cascade do |t|
    t.string "name"
    t.string "endpoint"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shippings", force: :cascade do |t|
    t.string "Shipping"
    t.bigint "carrier_id", null: false
    t.bigint "solicitude_id", null: false
    t.string "name_from"
    t.string "street_from"
    t.string "city_from"
    t.string "province_from"
    t.string "postal_code_from"
    t.string "countr_code_from"
    t.string "name_to"
    t.string "street_to"
    t.string "city_to"
    t.string "province_to"
    t.string "postal_code_to"
    t.string "countr_code_to"
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.string "dimensions_unit"
    t.integer "weight"
    t.string "weight_unit"
    t.string "status"
    t.string "shipment_id"
    t.string "label_url"
    t.string "id_response"
    t.string "tracking_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["carrier_id"], name: "index_shippings_on_carrier_id"
    t.index ["solicitude_id"], name: "index_shippings_on_solicitude_id"
  end

  create_table "solicitudes", force: :cascade do |t|
    t.date "fecha"
    t.string "status"
    t.string "tracking_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "shippings", "carriers"
  add_foreign_key "shippings", "solicitudes"
end
