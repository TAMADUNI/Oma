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

ActiveRecord::Schema[7.1].define(version: 2024_01_13_192059) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blobrates", force: :cascade do |t|
    t.bigint "line_id", null: false
    t.float "percentage"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_id"], name: "index_blobrates_on_line_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_departments_on_manager_id"
  end

  create_table "handovers", force: :cascade do |t|
    t.text "activities"
    t.float "blob_rates"
    t.float "ejection_rates"
    t.text "pending_issues"
    t.bigint "user_id", null: false
    t.boolean "acceptance_status"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "site_id"
    t.index ["user_id"], name: "index_handovers_on_user_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "name"
    t.bigint "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "maintenance_type"
    t.index ["site_id"], name: "index_lines_on_site_id"
  end

  create_table "lines_tasks", id: false, force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "line_id", null: false
    t.index ["line_id", "task_id"], name: "index_lines_tasks_on_line_id_and_task_id"
    t.index ["task_id", "line_id"], name: "index_lines_tasks_on_task_id_and_line_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_regions_on_department_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_sites_on_region_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.integer "line_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "startable"
    t.integer "completable"
  end

  create_table "user_sites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "site_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "department_id"
    t.integer "region_id"
    t.integer "site_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_work_sessions_on_task_id"
    t.index ["user_id"], name: "index_work_sessions_on_user_id"
  end

  add_foreign_key "blobrates", "lines"
  add_foreign_key "departments", "users", column: "manager_id", on_delete: :nullify
  add_foreign_key "handovers", "users"
  add_foreign_key "lines", "sites"
  add_foreign_key "regions", "departments"
  add_foreign_key "sites", "regions"
  add_foreign_key "work_sessions", "tasks"
  add_foreign_key "work_sessions", "users"
end
