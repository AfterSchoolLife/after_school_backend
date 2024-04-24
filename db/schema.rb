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

ActiveRecord::Schema[7.1].define(version: 2024_04_24_212814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "phonenumber"
    t.text "about"
    t.text "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "schedule_id"
    t.bigint "product_id"
    t.string "cart_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_carts_on_product_id"
    t.index ["schedule_id"], name: "index_carts_on_schedule_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
    t.text "image_url"
    t.uuid "created_by"
  end

  create_table "programs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
    t.text "image_url"
    t.uuid "created_by"
  end

  create_table "purchaseds", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.bigint "student_id", null: false
    t.bigint "schedule_id"
    t.bigint "product_id"
    t.string "cart_type"
    t.uuid "purchase_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["product_id"], name: "index_purchaseds_on_product_id"
    t.index ["schedule_id"], name: "index_purchaseds_on_schedule_id"
    t.index ["student_id"], name: "index_purchaseds_on_student_id"
    t.index ["user_id"], name: "index_purchaseds_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "days"
    t.time "start_time"
    t.time "end_time"
    t.date "start_date"
    t.date "end_date"
    t.string "age_group"
    t.decimal "price"
    t.boolean "is_active", default: true
    t.bigint "school_id", null: false
    t.bigint "program_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "teacher_name"
    t.decimal "cost_of_teacher"
    t.decimal "facility_rental"
    t.integer "total_available"
    t.integer "currently_available"
    t.uuid "created_by"
    t.index ["program_id"], name: "index_schedules_on_program_id"
    t.index ["school_id"], name: "index_schedules_on_school_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
    t.uuid "created_by"
  end

  create_table "students", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.integer "age"
    t.string "grade"
    t.string "pickup"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "parent_1_name"
    t.string "parent_2_name"
    t.string "parent_1_phone_number"
    t.string "parent_2_phone_number"
    t.string "emergency_1_name"
    t.string "emergency_2_name"
    t.string "emergency_1_relation"
    t.string "emergency_2_relation"
    t.string "emergency_1_phone_number"
    t.string "emergency_2_phone_number"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "carts", "products"
  add_foreign_key "carts", "schedules"
  add_foreign_key "carts", "users"
  add_foreign_key "purchaseds", "products"
  add_foreign_key "purchaseds", "schedules"
  add_foreign_key "purchaseds", "students"
  add_foreign_key "purchaseds", "users"
  add_foreign_key "schedules", "programs"
  add_foreign_key "schedules", "schools"
  add_foreign_key "students", "users"
end
