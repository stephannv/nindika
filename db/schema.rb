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

ActiveRecord::Schema.define(version: 2021_06_19_135808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", limit: 1024, null: false
    t.text "description"
    t.citext "slug"
    t.string "website_url", limit: 1024
    t.string "nsuid", limit: 32
    t.string "external_id", limit: 256, null: false
    t.string "boxart_url", limit: 1024
    t.string "banner_url", limit: 1024
    t.string "release_date_display", limit: 64
    t.date "release_date"
    t.string "content_rating", limit: 64
    t.jsonb "extra", default: {}, null: false
    t.string "publishers", default: [], null: false, array: true
    t.string "developers", default: [], null: false, array: true
    t.string "genres", default: [], null: false, array: true
    t.string "franchises", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_items_on_external_id", unique: true
  end

  create_table "raw_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id"
    t.string "external_id", limit: 256, null: false
    t.jsonb "data", default: {}, null: false
    t.string "checksum", limit: 512, null: false
    t.boolean "imported", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_raw_items_on_external_id", unique: true
    t.index ["imported"], name: "index_raw_items_on_imported", where: "(imported = false)"
    t.index ["item_id"], name: "index_raw_items_on_item_id", unique: true, where: "(item_id IS NOT NULL)"
  end

  add_foreign_key "raw_items", "items"
end
