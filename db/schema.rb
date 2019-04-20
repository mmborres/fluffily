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

ActiveRecord::Schema.define(version: 2019_04_20_131627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "breedappts", force: :cascade do |t|
    t.integer "dog_request_id"
    t.integer "dog_accept_id"
    t.text "status"
    t.date "breeddate"
    t.text "place"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.date "dob"
    t.text "name"
    t.text "image"
    t.text "sex"
    t.text "breed"
    t.text "color"
    t.integer "user_id"
    t.text "location"
    t.text "imagewithowner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "pref_sex"
    t.text "pref_breed"
    t.text "pref_color"
    t.text "pref_location"
    t.text "status"
  end

  create_table "dogwalkdates", force: :cascade do |t|
    t.integer "dog_request_id"
    t.integer "dog_accept_id"
    t.text "status"
    t.date "walkdate"
    t.text "place"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "woof_id"
    t.integer "sender_id"
    t.text "sender_name"
    t.text "message_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "dog_id"
    t.text "sex"
    t.text "breed"
    t.text "color"
    t.text "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "email"
    t.text "password_digest"
    t.date "dob"
    t.boolean "admin"
    t.text "name"
    t.text "image"
    t.text "sex"
    t.boolean "has_registered_dog"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "woofs", force: :cascade do |t|
    t.integer "dog_request_id"
    t.integer "dog_accept_id"
    t.text "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
