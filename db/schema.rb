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

ActiveRecord::Schema.define(version: 2020_10_27_203248) do

    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
  
    create_table "airports", force: :cascade do |t|
      t.string "code"
      t.string "name"
      t.string "city"
      t.string "country"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
    create_table "bookings", force: :cascade do |t|
      t.bigint "flight_id"
      t.bigint "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "purchased_amount"
      t.index ["flight_id"], name: "index_bookings_on_flight_id"
      t.index ["user_id"], name: "index_bookings_on_user_id"
    end
  
    create_table "flights", force: :cascade do |t|
      t.bigint "departure_airport_id"
      t.bigint "arrival_airport_id"
      t.datetime "takeoff"
      t.integer "duration"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "price"
      t.index ["arrival_airport_id"], name: "index_flights_on_arrival_airport_id"
      t.index ["departure_airport_id"], name: "index_flights_on_departure_airport_id"
    end
  
    create_table "users", force: :cascade do |t|
      t.string "name"
      t.string "email"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
    add_foreign_key "flights", "airports", column: "arrival_airport_id"
    add_foreign_key "flights", "airports", column: "departure_airport_id"
  end
  