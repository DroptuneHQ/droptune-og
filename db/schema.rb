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

ActiveRecord::Schema.define(version: 2018_08_20_212634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.bigint "artist_id"
    t.text "name"
    t.text "artwork_link"
    t.boolean "explicity", default: false
    t.integer "track_count"
    t.date "release_date"
    t.integer "itunes_id"
    t.text "itunes_link"
    t.text "spotify_id"
    t.text "spotify_image"
    t.text "spotify_link"
    t.integer "spotify_popularity"
    t.string "album_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "applemusic_id"
    t.string "applemusic_image"
    t.string "applemusic_link"
    t.index ["album_type"], name: "index_albums_on_album_type"
    t.index ["artist_id", "name"], name: "index_albums_on_artist_id_and_name"
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["name"], name: "index_albums_on_name"
    t.index ["release_date"], name: "index_albums_on_release_date"
  end

  create_table "artists", force: :cascade do |t|
    t.text "name"
    t.text "genre"
    t.integer "itunes_id"
    t.text "itunes_link"
    t.text "spotify_id"
    t.integer "spotify_followers"
    t.integer "spotify_popularity"
    t.text "spotify_image"
    t.text "spotify_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "applemusic_id"
    t.integer "year_started"
    t.integer "year_ended"
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "connections", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.string "settings"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_connections_on_provider"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["active"], name: "index_follows_on_active"
    t.index ["artist_id"], name: "index_follows_on_artist_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "music_videos", force: :cascade do |t|
    t.bigint "artist_id"
    t.string "name"
    t.date "release_date"
    t.string "image"
    t.string "source"
    t.string "source_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_music_videos_on_artist_id"
  end

  create_table "news", force: :cascade do |t|
    t.bigint "artists_id"
    t.string "title"
    t.text "summary"
    t.string "image_url"
    t.string "url"
    t.string "source_name"
    t.datetime "published_at"
    t.integer "invalid_reports"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artists_id"], name: "index_news_on_artists_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.jsonb "settings", default: {}, null: false
    t.string "username"
    t.string "name"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
