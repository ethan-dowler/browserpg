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

ActiveRecord::Schema[7.0].define(version: 2023_09_17_031736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", default: 0, null: false
    t.integer "xp", default: 0, null: false
    t.integer "current_hp", default: 0, null: false
    t.integer "base_hp", default: 0, null: false
    t.integer "base_attack", default: 0, null: false
    t.integer "base_defense", default: 0, null: false
  end

  create_table "dungeon_runs", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "dungeon_id", null: false
    t.bigint "current_room_id", null: false
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.string "completed_reason"
    t.index ["character_id"], name: "index_dungeon_runs_on_character_id"
    t.index ["current_room_id"], name: "index_dungeon_runs_on_current_room_id"
    t.index ["dungeon_id"], name: "index_dungeon_runs_on_dungeon_id"
  end

  create_table "dungeons", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
  end

  create_table "floors", force: :cascade do |t|
    t.bigint "dungeon_id", null: false
    t.string "name", null: false
    t.integer "level", null: false
    t.index ["dungeon_id"], name: "index_floors_on_dungeon_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.string "modifier_type", null: false
    t.string "stat", null: false
    t.integer "value", default: 1, null: false
    t.index ["source_id", "source_type", "modifier_type", "stat"], name: "index_modifiers_combo"
    t.index ["source_type", "source_id"], name: "index_modifiers_on_source"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "floor_id", null: false
    t.string "name", null: false
    t.boolean "entrance", default: false, null: false
    t.boolean "exit", default: false, null: false
    t.bigint "north_room_id"
    t.bigint "east_room_id"
    t.bigint "south_room_id"
    t.bigint "west_room_id"
    t.index ["east_room_id"], name: "index_rooms_on_east_room_id"
    t.index ["floor_id"], name: "index_rooms_on_floor_id"
    t.index ["north_room_id"], name: "index_rooms_on_north_room_id"
    t.index ["south_room_id"], name: "index_rooms_on_south_room_id"
    t.index ["west_room_id"], name: "index_rooms_on_west_room_id"
  end

  add_foreign_key "dungeon_runs", "rooms", column: "current_room_id"
  add_foreign_key "rooms", "rooms", column: "east_room_id"
  add_foreign_key "rooms", "rooms", column: "north_room_id"
  add_foreign_key "rooms", "rooms", column: "south_room_id"
  add_foreign_key "rooms", "rooms", column: "west_room_id"
end
