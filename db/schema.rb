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

ActiveRecord::Schema[7.0].define(version: 2023_09_23_153834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget_expenses", id: false, force: :cascade do |t|
    t.bigint "budget_id"
    t.bigint "expense_id"
    t.index ["budget_id"], name: "index_budget_expenses_on_budget_id"
    t.index ["expense_id"], name: "index_budget_expenses_on_expense_id"
  end

  create_table "budget_users", force: :cascade do |t|
    t.bigint "budget_id"
    t.bigint "user_id"
    t.index ["budget_id"], name: "index_budget_users_on_budget_id"
    t.index ["user_id"], name: "index_budget_users_on_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "total_payable_in_cents", default: 0, null: false
    t.integer "balance_to_pay_in_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections", force: :cascade do |t|
    t.integer "kind", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "budget_id", null: false
    t.string "name", null: false
    t.integer "price_in_cents", default: 0, null: false
    t.date "due_at", null: false
    t.integer "status", default: 1, null: false
    t.integer "kind", default: 1, null: false
    t.integer "installment_number", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "collection_id"
    t.index ["budget_id"], name: "index_expenses_on_budget_id"
    t.index ["collection_id"], name: "index_expenses_on_collection_id"
    t.index ["kind"], name: "index_expenses_on_kind"
    t.index ["status"], name: "index_expenses_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url", default: "http://www.gravatar.com/avatar/?d=mp"
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "expenses", "budgets"
  add_foreign_key "expenses", "collections"
end
