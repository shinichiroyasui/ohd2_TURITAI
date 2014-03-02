class CreateUserFacebookMusics < ActiveRecord::Migration
  def change
    create_table :user_facebook_musics do |t|
      t.integer :user_id, :null => false
      t.integer :facebook_music_id, :null => false
      t.timestamps
    end
    add_index :user_facebook_musics, [:user_id, :facebook_music_id], :name => :user_facebook_musics_idx, :unique => true
  end
end
