class CreateFacebookMovies < ActiveRecord::Migration
  def change
    create_table :facebook_movies do |t|
      t.integer :facebook_id, :null => false, :limit => 5
      t.string :name, :null => false
      t.timestamps
    end
    add_index :facebook_movies, :facebook_id, :name => :facebook_movies_idx, :unique => true
  end
end
