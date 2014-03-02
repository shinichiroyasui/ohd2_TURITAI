class CreateUserFacebookMovies < ActiveRecord::Migration
  def change
    create_table :user_facebook_movies do |t|
      t.integer :user_id, :null => false
      t.integer :facebook_movie_id, :null => false
      t.timestamps
    end
    add_index :user_facebook_movies, [:user_id, :facebook_movie_id], :name => :user_facebook_movies_idx, :unique => true
  end
end
