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

ActiveRecord::Schema.define(version: 20160225144601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "downloads", force: :cascade do |t|
    t.integer  "release_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "downloads", ["release_id"], name: "index_downloads_on_release_id", using: :btree
  add_index "downloads", ["user_id"], name: "index_downloads_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "payer_id"
    t.string   "payment_id"
    t.integer  "price_combo_id"
    t.decimal  "total"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "tax"
    t.decimal  "discount"
    t.integer  "user_id"
  end

  create_table "price_combos", force: :cascade do |t|
    t.string   "name"
    t.decimal  "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_combos_products", id: false, force: :cascade do |t|
    t.integer "price_combo_id"
    t.integer "product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "short_desc"
    t.text     "long_desc"
    t.decimal  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rank"
    t.string   "image"
    t.string   "small_image"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
    t.decimal  "price"
  end

  create_table "releases", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "format"
    t.datetime "release_date"
    t.decimal  "size"
    t.string   "version"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "physical_code"
  end

  add_index "releases", ["product_id"], name: "index_releases_on_product_id", using: :btree

  create_table "staged_purchases", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.string   "full_name"
    t.string   "country"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "woods_boxes", force: :cascade do |t|
    t.string   "name"
    t.integer  "itemset_id"
    t.boolean  "enabled"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_finds", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "item_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_footprints", force: :cascade do |t|
    t.integer  "scorecard_id"
    t.integer  "storytree_id"
    t.string   "footprint_data", limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_items", force: :cascade do |t|
    t.string   "name"
    t.integer  "value"
    t.string   "legend",     limit: 1500
    t.string   "image"
    t.integer  "itemset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_itemsets", force: :cascade do |t|
    t.string   "name"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_moverules", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_nodes", force: :cascade do |t|
    t.integer  "moverule_id"
    t.string   "name"
    t.string   "left_text",    limit: 30
    t.string   "right_text",   limit: 30
    t.integer  "storytree_id"
    t.integer  "tree_index"
    t.string   "main_text",    limit: 1500
    t.integer  "last_author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_paintballs", force: :cascade do |t|
    t.integer  "node_id"
    t.integer  "palette_id"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_palettes", force: :cascade do |t|
    t.string   "name"
    t.integer  "player_id"
    t.string   "fore_colour"
    t.string   "back_colour"
    t.string   "alt_colour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_players", force: :cascade do |t|
    t.integer  "silver_coins"
    t.string   "image"
    t.integer  "gold_coins"
    t.integer  "karma"
    t.integer  "most_recent_story"
    t.string   "description"
    t.integer  "total_equity"
    t.integer  "story_limit"
    t.integer  "item_limit"
    t.integer  "palette_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "woods_possibleitems", force: :cascade do |t|
    t.boolean  "enabled"
    t.boolean  "perpetual"
    t.integer  "itemset_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_scorecards", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "story_id"
    t.integer  "number_of_plays"
    t.integer  "total_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_stories", force: :cascade do |t|
    t.string   "name"
    t.integer  "player_id"
    t.string   "description"
    t.string   "cover_image"
    t.integer  "entry_tree"
    t.integer  "total_plays"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   default: false
  end

  create_table "woods_storytrees", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_tree_level"
    t.integer  "story_id"
    t.boolean  "deletable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_treelinks", force: :cascade do |t|
    t.integer  "node_id"
    t.boolean  "enabled"
    t.integer  "linked_tree"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "downloads", "releases"
  add_foreign_key "downloads", "users"
  add_foreign_key "releases", "products"
end
