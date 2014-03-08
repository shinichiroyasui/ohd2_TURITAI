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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140302132853) do

  create_table "facebook_movies", :force => true do |t|
    t.integer  "facebook_id", :limit => 8, :null => false
    t.string   "name",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "facebook_movies", ["facebook_id"], :name => "facebook_movies_idx", :unique => true

  create_table "facebook_musics", :force => true do |t|
    t.integer  "facebook_id", :limit => 8, :null => false
    t.string   "name",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "facebook_musics", ["facebook_id"], :name => "facebook_musics_idx", :unique => true

  create_table "facebook_places", :force => true do |t|
    t.integer  "facebook_id", :limit => 8, :null => false
    t.string   "name",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "facebook_places", ["facebook_id"], :name => "facebook_places_idx", :unique => true

  create_table "pairscores", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_destiny_scores", :force => true do |t|
    t.integer  "user1_id",                                  :null => false
    t.integer  "user2_id",                                  :null => false
    t.decimal  "score",      :precision => 10, :scale => 0, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "user_destiny_scores", ["user1_id", "user2_id"], :name => "user_destiny_scores_idx", :unique => true

  create_table "user_facebook_movies", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "facebook_movie_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_facebook_movies", ["user_id", "facebook_movie_id"], :name => "user_facebook_movies_idx", :unique => true

  create_table "user_facebook_musics", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "facebook_music_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_facebook_musics", ["user_id", "facebook_music_id"], :name => "user_facebook_musics_idx", :unique => true

  create_table "user_facebook_places", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "facebook_place_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "user_facebook_places", ["user_id", "facebook_place_id"], :name => "user_facebook_places_idx", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "facebook_id",          :limit => 8
    t.text     "gcm_registration_key"
    t.string   "android_id"
    t.text     "access_token"
    t.integer  "gender"
    t.date     "birthday"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["android_id"], :name => "users_idx", :unique => true

end
