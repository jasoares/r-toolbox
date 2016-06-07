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

ActiveRecord::Schema.define(version: 20160607123453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collaborations", force: :cascade do |t|
    t.boolean "author",           default: false
    t.boolean "contributor",      default: false
    t.boolean "creator",          default: false
    t.boolean "copyright_holder", default: false
    t.integer "collaborator_id"
    t.integer "version_id"
    t.index ["collaborator_id"], name: "index_collaborations_on_collaborator_id", using: :btree
    t.index ["version_id", "collaborator_id"], name: "index_collaborations_on_version_id_and_collaborator_id", unique: true, using: :btree
    t.index ["version_id"], name: "index_collaborations_on_version_id", using: :btree
  end

  create_table "collaborators", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_collaborators_on_name", unique: true, using: :btree
  end

  create_table "maintainers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_maintainers_on_email", unique: true, using: :btree
  end

  create_table "packages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_packages_on_name", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "value"
    t.datetime "publication"
    t.string   "title"
    t.string   "description"
    t.integer  "maintainer_id"
    t.integer  "package_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["maintainer_id"], name: "index_versions_on_maintainer_id", using: :btree
    t.index ["package_id", "value"], name: "index_versions_on_package_id_and_value", unique: true, using: :btree
    t.index ["package_id"], name: "index_versions_on_package_id", using: :btree
  end

  add_foreign_key "collaborations", "collaborators"
  add_foreign_key "collaborations", "versions"
  add_foreign_key "versions", "maintainers"
  add_foreign_key "versions", "packages"
end
