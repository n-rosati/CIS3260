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

ActiveRecord::Schema.define(version: 0) do
  create_table "players", force: :cascade do |t|
    t.primary_key "player_id", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", null: false
    t.string "colour"
    t.integer "wins", default: 0
    t.integer "losses", default: 0
  end

  create_table "games", force: :cascade do |t|
    t.primary_key "board_id", null: false
    t.string "game_phase"
    t.string "game_status"
    t.integer "winner"
    t.string "draw_flag"
  end

  create_table "boards", force: :cascade do |t|
    t.primary_key "board_id", null: false
  end

  create_table "bags", force: :cascade do |t|
    t.primary_key "bag_id", null: false
    t.string "piece_list"
  end

  create_table "pieces", force: :cascade do |t|
    t.primary_key "piece_id", null: false
    t.string "piece_status"
    t.string "colour"
  end

  create_table "intersections", force: :cascade do |t|
    t.primary_key "intersection_id", null: false
    t.string "row"
    t.string "column"
  end
end
