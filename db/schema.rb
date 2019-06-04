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

ActiveRecord::Schema.define(version: 2019_06_04_194514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.bigint "artist_id"
    t.text "name"
    t.text "artwork_link"
    t.date "release_date"
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
    t.string "artist_slug"
    t.index "date_part('month'::text, release_date)", name: "index_on_albums_release_date_month"
    t.index "date_part('year'::text, release_date)", name: "index_on_albums_release_date_year"
    t.index ["album_type"], name: "index_albums_on_album_type"
    t.index ["artist_id", "name"], name: "index_albums_on_artist_id_and_name"
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["artist_slug"], name: "index_albums_on_artist_slug"
    t.index ["name"], name: "index_albums_on_name"
    t.index ["release_date"], name: "index_albums_on_release_date"
  end

  create_table "artists", force: :cascade do |t|
    t.text "name"
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
    t.string "external_homepage"
    t.string "external_twitter"
    t.string "external_facebook"
    t.string "external_instagram"
    t.string "external_wikipedia"
    t.string "external_youtube"
    t.datetime "imvdb_last_updated_at"
    t.datetime "musicbrainz_last_updated_at"
    t.datetime "spotify_last_updated_at"
    t.datetime "applemusic_last_updated_at"
    t.jsonb "genres", default: {}, null: false
    t.index ["applemusic_last_updated_at"], name: "index_artists_on_applemusic_last_updated_at"
    t.index ["genres"], name: "index_artists_on_genres", using: :gin
    t.index ["imvdb_last_updated_at"], name: "index_artists_on_imvdb_last_updated_at"
    t.index ["musicbrainz_last_updated_at"], name: "index_artists_on_musicbrainz_last_updated_at"
    t.index ["name"], name: "index_artists_on_name"
    t.index ["spotify_last_updated_at"], name: "index_artists_on_spotify_last_updated_at"
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
    t.string "artist_slug"
    t.index ["artist_id", "source_data"], name: "index_music_videos_on_artist_id_and_source_data"
    t.index ["artist_id"], name: "index_music_videos_on_artist_id"
    t.index ["artist_slug"], name: "index_music_videos_on_artist_slug"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "streams", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "artist_id"
    t.bigint "album_id"
    t.string "name"
    t.datetime "listened_at"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_streams_on_album_id"
    t.index ["artist_id"], name: "index_streams_on_artist_id"
    t.index ["user_id"], name: "index_streams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", default: ""
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
    t.text "apple_music_token"
    t.boolean "admin", default: false
    t.datetime "spotify_connected_at"
    t.datetime "spotify_disconnected_at"
    t.datetime "applemusic_connected_at"
    t.datetime "applemusic_disconnected_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
