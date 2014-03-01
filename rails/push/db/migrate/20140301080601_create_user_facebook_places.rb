class CreateUserFacebookPlaces < ActiveRecord::Migration
  def change
    create_table :user_facebook_places do |t|
      t.integer :user_id, :null => false
      t.integer :facebook_place_id, :null => false
      t.timestamps
    end
    add_index :user_facebook_places, [:user_id, :facebook_place_id], :name => :user_facebook_places_idx, :unique => true
  end
end
