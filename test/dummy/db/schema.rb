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

ActiveRecord::Schema.define(version: 2021_04_19_122752) do

  create_table "eivid_owners", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "external_id"
    t.string "folder_id"
  end

  create_table "eivid_video_resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "video_id"
    t.integer "resource_id"
    t.string "resource_type"
  end

  create_table "eivid_videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "url_embedded"
    t.boolean "uploaded", default: false
    t.string "vimeo_id"
    t.string "url_sd"
    t.string "url_hd"
    t.string "url_thumbnail"
  end

end
