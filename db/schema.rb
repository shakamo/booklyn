# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160118170144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "category_code"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_code"], name: "index_categories_on_category_code", using: :btree

  create_table "contents", force: :cascade do |t|
    t.string   "title"
    t.string   "initial"
    t.string   "description", limit: 16384
    t.integer  "category_id"
    t.integer  "schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trim_title"
    t.text     "error"
    t.integer  "tid"
    t.integer  "akid"
  end

  add_index "contents", ["category_id"], name: "index_contents_on_category_id", using: :btree
  add_index "contents", ["schedule_id"], name: "index_contents_on_schedule_id", using: :btree

  create_table "contents_holders", force: :cascade do |t|
    t.string   "contents_holder_code"
    t.string   "contents_holder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents_holders", ["contents_holder_code"], name: "index_contents_holders_on_contents_holder_code", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "direct_urls", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "direct_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", force: :cascade do |t|
    t.integer  "episode_num"
    t.string   "episode_name"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "error"
  end

  add_index "episodes", ["content_id"], name: "index_episodes_on_content_id", using: :btree
  add_index "episodes", ["episode_num"], name: "index_episodes_on_episode_num", using: :btree

  create_table "errors", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "table_name"
    t.integer  "generic_id"
  end

  create_table "phantom_js", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "platforms", force: :cascade do |t|
    t.string   "platform_code"
    t.string   "platform_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platforms", ["platform_code"], name: "index_platforms_on_platform_code", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "post"
    t.text     "url"
    t.string   "short_url"
    t.integer  "episode_id"
    t.integer  "contents_holder_id"
    t.integer  "platform_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "direct_url"
    t.string   "available"
    t.text     "error"
  end

  add_index "posts", ["contents_holder_id"], name: "index_posts_on_contents_holder_id", using: :btree
  add_index "posts", ["episode_id"], name: "index_posts_on_episode_id", using: :btree
  add_index "posts", ["platform_id"], name: "index_posts_on_platform_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.string   "schedule_code"
    t.string   "schedule_name"
    t.string   "week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

  add_index "schedules", ["schedule_code"], name: "index_schedules_on_schedule_code", using: :btree

  create_table "term_frequencies", force: :cascade do |t|
    t.integer  "content_id"
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_num"
  end

  add_index "term_frequencies", ["content_id"], name: "index_term_frequencies_on_content_id", using: :btree

end
