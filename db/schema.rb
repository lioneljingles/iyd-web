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

ActiveRecord::Schema.define(version: 20141012175321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: true do |t|
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "state",       null: false
    t.string   "slug",        null: false
    t.string   "name",        null: false
    t.text     "summary",     null: false
    t.text     "description"
    t.string   "website"
    t.string   "phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "district",    null: false
    t.string   "city",        null: false
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "visibility"
    t.integer  "order"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree
  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "organizations_tags", force: true do |t|
    t.integer "organization_id"
    t.integer "tag_id"
  end

  add_index "organizations_tags", ["organization_id", "tag_id"], name: "index_organizations_tags_on_organization_id_and_tag_id", unique: true, using: :btree
  add_index "organizations_tags", ["tag_id"], name: "index_organizations_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string "name", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "users", force: true do |t|
    t.integer  "role",        default: 0, null: false
    t.string   "email",                   null: false
    t.string   "password"
    t.string   "reset_token"
    t.string   "name",                    null: false
    t.string   "settings",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
