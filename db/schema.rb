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

ActiveRecord::Schema[7.2].define(version: 2025_01_13_163653) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["record_type", "record_id"], name: "index_active_storage_attachments_on_record_type_and_record_id"
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "qty", default: 1, null: false
    t.uuid "variant_id", null: false
    t.uuid "user_id"
    t.uuid "guest_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_session_id"], name: "index_carts_on_guest_session_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
    t.index ["variant_id", "user_id", "guest_session_id"], name: "index_carts_on_variant_id_and_user_id_and_guest_session_id", unique: true
    t.index ["variant_id"], name: "index_carts_on_variant_id"
    t.check_constraint "user_id IS NOT NULL AND guest_session_id IS NULL OR user_id IS NULL AND guest_session_id IS NOT NULL", name: "cart_ownership_cant_be_both"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["name", "ancestry"], name: "index_categories_on_name_and_ancestry", unique: true
  end

  create_table "guest_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "display_name"
    t.string "placeholder"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_options_on_name", unique: true
  end

  create_table "order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "variant_id"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "qty", default: 1, null: false
    t.integer "discount_percent", default: 0, null: false
    t.json "variant_capture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
  end

  create_table "order_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_order_statuses_on_name", unique: true
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "order_status_id", null: false
    t.uuid "guest_session_id"
    t.uuid "payment_method_id"
    t.decimal "shipping_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "refund_amount", precision: 10, scale: 2
    t.text "refund_reason"
    t.text "return_reason"
    t.text "cancelled_by"
    t.datetime "cancelled_at"
    t.datetime "placed_at"
    t.string "logistic_name"
    t.string "logistic_url"
    t.string "logistic_ref"
    t.text "internal_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_session_id"], name: "index_orders_on_guest_session_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["payment_method_id"], name: "index_orders_on_payment_method_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.boolean "enable", default: false, null: false
    t.json "credentials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_payment_methods_on_code", unique: true
    t.index ["name"], name: "index_payment_methods_on_name"
  end

  create_table "product_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id", "category_id"], name: "index_product_categories_on_product_id_and_category_id", unique: true
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "product_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "option_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_product_options_on_option_id"
    t.index ["product_id"], name: "index_product_options_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "currency", default: "PHP", null: false
    t.boolean "has_variant", default: false, null: false
    t.boolean "promotable", default: true, null: false
    t.boolean "order_must_login", default: false, null: false
    t.decimal "lowest_price", precision: 10, scale: 2
    t.decimal "highest_price", precision: 10, scale: 2
    t.decimal "review_avg_rating", precision: 1, scale: 1, default: "0.0"
    t.integer "discount_percent", default: 0, null: false
    t.integer "review_count", default: 0
    t.date "available_on"
    t.date "discontinue_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["available_on"], name: "index_products_on_available_on"
    t.index ["discontinue_on"], name: "index_products_on_discontinue_on"
    t.index ["highest_price"], name: "index_products_on_highest_price"
    t.index ["lowest_price"], name: "index_products_on_lowest_price"
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "seos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.string "meta_title"
    t.string "meta_description"
    t.string "meta_keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_seos_on_product_id"
  end

  create_table "shipping_details", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "shippable_type", null: false
    t.uuid "shippable_id", null: false
    t.string "fullname", null: false
    t.string "phone_no", null: false
    t.string "email"
    t.string "street", null: false
    t.string "barangay", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.string "postal_code"
    t.boolean "default", default: false, null: false
    t.boolean "save_information", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shippable_type", "shippable_id"], name: "index_shipping_details_on_shippable"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "phone_no"
    t.string "name"
    t.boolean "admin", default: false, null: false
    t.string "provider", default: "phone_no"
    t.string "uid"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_no"], name: "index_users_on_phone_no", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_option_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "illustration", default: "", null: false
    t.uuid "variant_id", null: false
    t.uuid "product_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_variant_option_values_on_name"
    t.index ["product_option_id"], name: "index_variant_option_values_on_product_option_id"
    t.index ["variant_id", "product_option_id"], name: "index_variant_option_values_on_variant_id_and_product_option_id", unique: true
    t.index ["variant_id"], name: "index_variant_option_values_on_variant_id"
  end

  create_table "variants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.string "sku"
    t.integer "position"
    t.decimal "cost", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "count_on_hand", default: 0, null: false
    t.boolean "is_master", default: false, null: false
    t.boolean "trackable", default: true, null: false
    t.boolean "backorderable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_variants_on_position"
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["sku"], name: "index_variants_on_sku"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "carts", "guest_sessions"
  add_foreign_key "carts", "users"
  add_foreign_key "carts", "variants"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "variants"
  add_foreign_key "orders", "guest_sessions"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "payment_methods"
  add_foreign_key "orders", "users"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "product_options", "options"
  add_foreign_key "product_options", "products"
  add_foreign_key "seos", "products"
  add_foreign_key "variant_option_values", "product_options"
  add_foreign_key "variant_option_values", "variants"
  add_foreign_key "variants", "products"
end
