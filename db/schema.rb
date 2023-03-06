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

ActiveRecord::Schema[7.0].define(version: 2023_03_05_173630) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.boolean "income"
    t.boolean "untracked"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.date "date"
    t.decimal "amount", precision: 8, scale: 2
    t.string "notes"
    t.string "category_name"
    t.boolean "income"
    t.boolean "untracked"
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tag_id"
    t.index ["category_id"], name: "index_entries_on_category_id"
    t.index ["tag_id"], name: "index_entries_on_tag_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "recurrables", force: :cascade do |t|
    t.string "name"
    t.text "rule"
    t.decimal "amount"
    t.string "notes"
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_recurrables_on_category_id"
    t.index ["tag_id"], name: "index_recurrables_on_tag_id"
    t.index ["user_id"], name: "index_recurrables_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year_view"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entries", "categories"
  add_foreign_key "entries", "tags"
  add_foreign_key "entries", "users"
  add_foreign_key "recurrables", "categories"
  add_foreign_key "recurrables", "tags"
  add_foreign_key "recurrables", "users"
end
