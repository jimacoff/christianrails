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

ActiveRecord::Schema.define(version: 20181012233339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "crm_assistants", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "personality_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "email_me_daily", default: false
  end

  create_table "crm_books", force: :cascade do |t|
    t.integer  "assistant_id"
    t.string   "title"
    t.string   "author"
    t.integer  "desire_to_read"
    t.integer  "status_id",      default: 0
    t.datetime "finished_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "crm_contacts", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "business"
    t.string   "positiontitle"
    t.string   "source"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.integer  "assistant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "crm_ideas", force: :cascade do |t|
    t.integer  "assistant_id"
    t.string   "name"
    t.integer  "status_id",    default: 0
    t.datetime "completed_on"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "notes"
  end

  create_table "crm_mailouts", force: :cascade do |t|
    t.integer  "assistant_id"
    t.string   "type_id"
    t.integer  "status_id",    default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "crm_meetings", force: :cascade do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.integer  "assistant_id"
    t.datetime "date_time"
    t.integer  "status_id",    default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "closed_at"
    t.string   "location",     default: ""
    t.text     "agenda"
    t.text     "notes"
  end

  create_table "crm_obligations", force: :cascade do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.integer  "assistant_id"
    t.datetime "due_at"
    t.integer  "status_id",    default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "closed_at"
    t.text     "notes"
  end

  create_table "crm_tasks", force: :cascade do |t|
    t.integer  "assistant_id"
    t.string   "name"
    t.integer  "type_id",           default: 0
    t.datetime "due_at"
    t.integer  "recurral_period",   default: 30
    t.integer  "recurral_weekday",  default: 0
    t.integer  "recurral_monthday", default: 1
    t.integer  "status_id",         default: 0
    t.datetime "closed_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "notes"
  end

  create_table "logs", force: :cascade do |t|
    t.string   "description"
    t.string   "location"
    t.integer  "type_id",     default: 0
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "melons", force: :cascade do |t|
    t.integer  "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_signups", force: :cascade do |t|
    t.string   "email"
    t.integer  "newsletters_received", default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "nuggets", force: :cascade do |t|
    t.integer  "serial_number"
    t.string   "joke",           limit: 76
    t.string   "access_code"
    t.boolean  "disbursed",                 default: false
    t.integer  "unlocked_by_id"
    t.datetime "unlocked_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "store_digital_purchases", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "order_id"
    t.integer  "type_id",     default: 0
    t.integer  "price_cents", default: 0
  end

  create_table "store_distributions", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "purchaser_id"
    t.integer  "quantity"
    t.text     "message"
    t.integer  "status_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "store_downloads", force: :cascade do |t|
    t.integer  "release_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["release_id"], name: "index_store_downloads_on_release_id", using: :btree
    t.index ["user_id"], name: "index_store_downloads_on_user_id", using: :btree
  end

  create_table "store_free_gifts", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "recipient_id"
    t.string   "origin"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "giver_id"
  end

  create_table "store_lifetime_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cost_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
  end

  create_table "store_orders", force: :cascade do |t|
    t.string   "payer_id"
    t.string   "payment_id"
    t.integer  "price_combo_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "total_cents",         default: 0
    t.integer  "tax_cents",           default: 0
    t.integer  "discount_cents",      default: 0
    t.integer  "shipping_cost_cents", default: 0
  end

  create_table "store_physical_purchases", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "price_cents"
    t.integer  "quantity"
    t.integer  "type_id",     default: 2
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "store_price_combos", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "discount_cents", default: 0
  end

  create_table "store_price_combos_products", id: false, force: :cascade do |t|
    t.integer "price_combo_id"
    t.integer "product_id"
  end

  create_table "store_products", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.text     "short_desc"
    t.text     "long_desc"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "rank"
    t.string   "image"
    t.string   "small_image"
    t.boolean  "coming_soon",          default: false
    t.string   "slug"
    t.string   "logo_image"
    t.string   "filename"
    t.string   "popularity_image"
    t.integer  "physical_sales",       default: 0
    t.boolean  "free_on_signup",       default: false
    t.boolean  "giftpackable",         default: false
    t.integer  "price_cents",          default: 0
    t.integer  "giftpack_price_cents", default: 0
    t.integer  "physical_price_cents", default: 0
    t.integer  "shipping_cost_cents",  default: 0
    t.string   "goodreads_link"
  end

  create_table "store_releases", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "format"
    t.datetime "release_date"
    t.decimal  "size"
    t.string   "version"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "physical_code"
    t.string   "isbn",          default: ""
    t.index ["product_id"], name: "index_store_releases_on_product_id", using: :btree
  end

  create_table "store_staged_purchases", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "type_id",    default: 0
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
    t.string   "first_name"
    t.string   "country"
    t.boolean  "admin",                  default: false
    t.string   "last_name",              default: ""
    t.boolean  "crm_access",             default: true
    t.string   "time_zone",              default: "UTC"
    t.boolean  "send_me_emails",         default: false
    t.integer  "books_given",            default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.integer  "invited_for_product_id"
    t.datetime "last_gift_nudge"
    t.string   "company"
    t.boolean  "purchaser",              default: false
    t.hstore   "progress_list"
    t.hstore   "nudges"
    t.datetime "blocked_at"
    t.integer  "nugget_attempts",        default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["progress_list"], name: "index_users_on_progress_list", using: :gin
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "watch_properties", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "expected_response"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "last_checked"
  end

  create_table "woods_boxes", force: :cascade do |t|
    t.integer  "itemset_id"
    t.boolean  "enabled",    default: true
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_finds", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.integer  "item_id",    null: false
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_footprints", force: :cascade do |t|
    t.integer  "scorecard_id"
    t.integer  "storytree_id"
    t.string   "footprint_data", limit: 4096
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_item_downloads", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_woods_item_downloads_on_item_id", using: :btree
    t.index ["player_id"], name: "index_woods_item_downloads_on_player_id", using: :btree
  end

  create_table "woods_items", force: :cascade do |t|
    t.string   "name",              limit: 100,              null: false
    t.integer  "value",                          default: 1
    t.string   "legend",            limit: 3000
    t.string   "image",             limit: 60
    t.integer  "itemset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winning_condition",              default: 0
  end

  create_table "woods_itemsets", force: :cascade do |t|
    t.string   "name",       limit: 60
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_nodes", force: :cascade do |t|
    t.integer  "moverule_id"
    t.string   "name",         limit: 60
    t.string   "left_text",    limit: 60
    t.string   "right_text",   limit: 60
    t.integer  "storytree_id"
    t.integer  "tree_index"
    t.string   "node_text",    limit: 3000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_paintballs", force: :cascade do |t|
    t.integer  "node_id"
    t.integer  "palette_id"
    t.boolean  "enabled",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_palettes", force: :cascade do |t|
    t.string   "name",        limit: 100
    t.string   "fore_colour",             default: "#000000"
    t.string   "back_colour",             default: "#ffffff"
    t.string   "alt_colour",              default: "#ffffff"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_players", force: :cascade do |t|
    t.integer  "silver_coins",                  default: 0
    t.string   "image",             limit: 60
    t.integer  "gold_coins",                    default: 0
    t.integer  "karma",                         default: 0
    t.integer  "most_recent_story"
    t.string   "description",       limit: 510
    t.integer  "total_equity",                  default: 0
    t.integer  "story_limit",                   default: 10
    t.integer  "item_limit",                    default: 100
    t.integer  "palette_limit",                 default: 100
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_possibleitems", force: :cascade do |t|
    t.boolean  "enabled",    default: true
    t.boolean  "perpetual",  default: false
    t.integer  "itemset_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_scorecards", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "story_id"
    t.integer  "number_of_plays", default: 1
    t.integer  "total_score",     default: 0
    t.integer  "lefts",           default: 0
    t.integer  "rights",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_stories", force: :cascade do |t|
    t.string   "name",                 limit: 50,                   null: false
    t.integer  "player_id"
    t.string   "description",          limit: 1000
    t.integer  "entry_tree_id"
    t.integer  "total_plays"
    t.boolean  "published",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "store_link_text"
    t.boolean  "allow_remote_syncing",              default: false
    t.string   "slug",                              default: ""
  end

  create_table "woods_storytrees", force: :cascade do |t|
    t.string   "name",       limit: 60,                 null: false
    t.integer  "max_level",             default: 1,     null: false
    t.integer  "story_id",                              null: false
    t.boolean  "deletable",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "woods_treelinks", force: :cascade do |t|
    t.integer  "node_id"
    t.boolean  "enabled",        default: true
    t.integer  "linked_tree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "store_downloads", "store_releases", column: "release_id"
  add_foreign_key "store_downloads", "users"
  add_foreign_key "store_releases", "store_products", column: "product_id"
  add_foreign_key "woods_item_downloads", "woods_items", column: "item_id"
  add_foreign_key "woods_item_downloads", "woods_players", column: "player_id"
end
