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

ActiveRecord::Schema.define(version: 20190129112435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "body",       null: false
    t.integer  "user_id",    null: false
    t.integer  "meetup_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["meetup_id"], name: "index_comments_on_meetup_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "meetups", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "theme",       null: false
    t.datetime "date",        null: false
    t.datetime "begin_time",  null: false
    t.datetime "end_time",    null: false
    t.string   "location",    null: false
    t.string   "description", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "meetups", ["user_id"], name: "index_meetups_on_user_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "meetup_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signings", force: :cascade do |t|
    t.datetime "date",        null: false
    t.integer  "user_id",     null: false
    t.integer  "provider_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.string   "avatar_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "comments", "meetups"
  add_foreign_key "comments", "users"
  add_foreign_key "meetups", "users"
end
