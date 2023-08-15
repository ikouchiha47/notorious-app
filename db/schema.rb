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

ActiveRecord::Schema[7.0].define(version: 2023_08_15_172338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "address_line_a", null: false
    t.text "address_line_b"
    t.integer "zip_code", null: false
    t.integer "alternate_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "carts", id: false, force: :cascade do |t|
    t.string "cart_id", null: false
    t.string "user_id", default: ""
    t.string "product_item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.string "cart_state", default: "processing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cart_token"
    t.datetime "cart_token_expires_at", null: false
    t.boolean "shareable", default: false
    t.text "item_properties", default: "", null: false
    t.index ["cart_id"], name: "index_carts_on_cart_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_category_id"
    t.index ["parent_category_id"], name: "index_categories_on_parent_category_id"
  end

  create_table "orders", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "cart_id", null: false
    t.string "user_id", null: false
    t.integer "amount", default: 0, null: false
    t.string "payment_status", default: "pending", null: false
    t.string "order_status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_id", null: false
    t.string "order_token"
    t.datetime "order_token_expires_at", null: false
    t.string "alternate_number"
    t.index ["id"], name: "index_orders_on_id", unique: true
  end

  create_table "product_items", id: :string, force: :cascade do |t|
    t.string "product_id", null: false
    t.integer "quantity", default: 10, null: false
    t.text "locations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "details", default: {}, null: false
    t.index ["product_id"], name: "index_product_items_on_product_id"
  end

  create_table "products", id: :string, force: :cascade do |t|
    t.string "sku", null: false
    t.string "sku_provider", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "price", null: false
    t.string "gender", default: "unisex", null: false
    t.text "images", null: false
    t.boolean "available", default: false, null: false
    t.boolean "is_limited_edition", default: true, null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_featured", default: false, null: false
    t.string "product_type", default: "over::tee", null: false
    t.index ["sku"], name: "index_products_on_sku"
  end

  create_table "tokens", id: false, force: :cascade do |t|
    t.string "token_type", null: false
    t.string "hashed_token", null: false
    t.datetime "expires_at", null: false
    t.string "hashed_refresh_token"
    t.datetime "refresh_expires_at"
    t.boolean "revoked", default: false, null: false
    t.string "resource_id", null: false
    t.string "resource_type"
    t.index ["hashed_token", "hashed_refresh_token"], name: "index_tokens_on_hashed_token_and_hashed_refresh_token"
    t.index ["hashed_token", "token_type"], name: "index_tokens_on_hashed_token_and_token_type"
    t.index ["resource_id"], name: "index_tokens_on_resource_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "user_type", default: "guest", null: false
    t.string "email", null: false
    t.string "hashed_password", null: false
    t.integer "country_code"
    t.string "number", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
