class CreateFacebookMusics < ActiveRecord::Migration
  def change
    create_table :facebook_musics do |t|
      t.integer :facebook_id, :null => false, :limit => 5
      t.string :name, :null => false
      t.timestamps
    end
    add_index :facebook_musics, :facebook_id, :name => :facebook_musics_idx, :unique => true
  end
end
