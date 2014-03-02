class CreateFacebookPlaces < ActiveRecord::Migration
  def change
    create_table :facebook_places do |t|
      t.integer :facebook_id, :limit => 5, :null => false
      t.string :name, :null => false
      t.timestamps
    end
    add_index :facebook_places, [:facebook_id], :name => :facebook_places_idx, :unique => true
  end
end
