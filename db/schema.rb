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

ActiveRecord::Schema.define(version: 2021_06_12_212422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_offer_departments", force: :cascade do |t|
    t.bigint "api_offer_id", null: false
    t.bigint "department_id", null: false
    t.index ["api_offer_id"], name: "index_api_offer_departments_on_api_offer_id"
    t.index ["department_id"], name: "index_api_offer_departments_on_department_id"
  end

  create_table "api_offers", force: :cascade do |t|
    t.datetime "created_at", default: "2021-06-13 12:18:41"
    t.decimal "price"
    t.string "company"
    t.index ["company"], name: "index_api_offers_on_company"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_departments_on_name"
  end

  create_table "offer_departments", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "department_id", null: false
    t.index ["department_id"], name: "index_offer_departments_on_department_id"
    t.index ["offer_id"], name: "index_offer_departments_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.datetime "created_at", default: "2021-06-13 12:18:41"
    t.decimal "price"
    t.string "company"
    t.index ["company"], name: "index_offers_on_company"
    t.index ["price"], name: "index_offers_on_price"
  end

  create_table "user_departments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "department_id", null: false
    t.index ["department_id"], name: "index_user_departments_on_department_id"
    t.index ["user_id"], name: "index_user_departments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "company"
  end

  add_foreign_key "api_offer_departments", "api_offers"
  add_foreign_key "api_offer_departments", "departments"
  add_foreign_key "offer_departments", "departments"
  add_foreign_key "offer_departments", "offers"
  add_foreign_key "user_departments", "departments"
  add_foreign_key "user_departments", "users"
end
