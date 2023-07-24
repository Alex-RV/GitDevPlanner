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

ActiveRecord::Schema.define(version: 2023_07_24_014332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collaborators", force: :cascade do |t|
    t.string "login"
    t.string "avatar_url"
    t.string "html_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.string "noteable_type", null: false
    t.bigint "noteable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable"
  end

  create_table "owners", force: :cascade do |t|
    t.string "login"
    t.string "html_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "repository_id"
    t.string "name"
    t.string "owner_login"
    t.string "html_url"
    t.string "private"
    t.datetime "updated_repo_at"
    t.datetime "pushed_at"
    t.datetime "last_commit_date"
    t.string "last_commit_sha"
    t.text "last_commit_message"
    t.text "last_commit_author"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "done", default: false
    t.bigint "repository_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["repository_id"], name: "index_tasks_on_repository_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "uid"
    t.string "github_access_token"
    t.string "avatar_url"
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "repositories", "users"
  add_foreign_key "tasks", "repositories"
  add_foreign_key "tasks", "users"
end
