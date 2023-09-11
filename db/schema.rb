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

ActiveRecord::Schema[7.0].define(version: 2023_03_24_004816) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "sale_event_id", null: false
    t.bigint "user_id"
    t.string "state", default: "pending", null: false
    t.string "delivery_address"
    t.datetime "delivered_at"
    t.string "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_deliveries_on_order_id"
    t.index ["sale_event_id"], name: "index_deliveries_on_sale_event_id"
    t.index ["user_id"], name: "index_deliveries_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity"
    t.integer "unit_price_in_cents"
    t.bigint "order_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.integer "price_in_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "pending", null: false
    t.bigint "sale_event_id"
    t.boolean "is_delivery", default: true, null: false
    t.text "notes", default: "", null: false
    t.index ["sale_event_id"], name: "index_orders_on_sale_event_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_in_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_events", force: :cascade do |t|
    t.date "date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "address"
    t.string "gps_link"
    t.string "name"
    t.string "reference_point"
    t.string "district"
    t.integer "role", default: 1, null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "deliveries", "orders"
  add_foreign_key "deliveries", "sale_events"
  add_foreign_key "deliveries", "users"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "orders", "sale_events"
  add_foreign_key "orders", "users"
end
