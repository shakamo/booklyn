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

ActiveRecord::Schema.define(version: 20140824024203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "category_code"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_code"], name: "index_categories_on_category_code", using: :btree

  create_table "contents", force: true do |t|
    t.string   "title"
    t.string   "initial"
    t.string   "description", limit: 1024
    t.integer  "category_id"
    t.integer  "schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trim_title"
  end

  add_index "contents", ["category_id"], name: "index_contents_on_category_id", using: :btree
  add_index "contents", ["schedule_id"], name: "index_contents_on_schedule_id", using: :btree

  create_table "contents_holders", force: true do |t|
    t.string   "contents_holder_code"
    t.string   "contents_holder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents_holders", ["contents_holder_code"], name: "index_contents_holders_on_contents_holder_code", using: :btree

  create_table "episodes", force: true do |t|
    t.integer  "episode_num"
    t.string   "episode_name"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["content_id"], name: "index_episodes_on_content_id", using: :btree
  add_index "episodes", ["episode_num"], name: "index_episodes_on_episode_num", using: :btree

  create_table "images", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "table_name"
    t.integer  "generic_id"
  end

  create_table "platforms", force: true do |t|
    t.string   "platform_code"
    t.string   "platform_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platforms", ["platform_code"], name: "index_platforms_on_platform_code", using: :btree

  create_table "posts", force: true do |t|
    t.string   "post"
    t.string   "url"
    t.string   "short_url"
    t.integer  "episode_id"
    t.integer  "contents_holder_id"
    t.integer  "platform_id"
    t.boolean  "is_available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["contents_holder_id"], name: "index_posts_on_contents_holder_id", using: :btree
  add_index "posts", ["episode_id"], name: "index_posts_on_episode_id", using: :btree
  add_index "posts", ["platform_id"], name: "index_posts_on_platform_id", using: :btree

  create_table "schedules", force: true do |t|
    t.string   "schedule_code"
    t.string   "schedule_name"
    t.string   "week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

  add_index "schedules", ["schedule_code"], name: "index_schedules_on_schedule_code", using: :btree

end
