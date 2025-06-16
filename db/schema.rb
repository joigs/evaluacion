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

ActiveRecord::Schema[7.1].define(version: 2025_06_16_210036) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "facturacions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.date "solicitud", default: -> { "curdate()" }
    t.date "emicion"
    t.date "entregado"
    t.integer "resultado", default: 0
    t.date "oc"
    t.date "factura"
    t.date "fecha_inspeccion"
    t.float "precio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "pesos"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "text", null: false
    t.integer "notification_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications_facturacions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.bigint "facturacion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facturacion_id"], name: "fk_rails_bcdbe45dbc"
    t.index ["notification_id", "facturacion_id"], name: "index_notifications_facturacions_on_notification_and_facturacion", unique: true
  end

  create_table "observacions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "texto"
    t.bigint "facturacion_id", null: false
    t.bigint "user_id"
    t.integer "momento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facturacion_id"], name: "fk_rails_e911727f32"
    t.index ["user_id"], name: "fk_rails_e43b4d7784"
  end

  create_table "oxies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.integer "numero_conductores"
    t.decimal "suma", precision: 10, scale: 2
    t.decimal "total_uf", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year", "month"], name: "index_oxies_on_year_and_month", unique: true
  end

  create_table "oxy_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.date "fecha"
    t.bigint "oxy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oxy_id"], name: "index_oxy_records_on_oxy_id"
  end

  create_table "permisos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_permisos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "permiso_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permiso_id"], name: "fk_rails_8162d36b66"
    t.index ["user_id"], name: "fk_rails_d93a563f7f"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.string "real_name", default: "", null: false
    t.string "email"
    t.boolean "tabla", default: true
    t.boolean "super", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notifications_facturacions", "facturacions"
  add_foreign_key "notifications_facturacions", "notifications"
  add_foreign_key "observacions", "facturacions"
  add_foreign_key "observacions", "users"
  add_foreign_key "oxy_records", "oxies"
  add_foreign_key "user_permisos", "permisos"
  add_foreign_key "user_permisos", "users"
end
