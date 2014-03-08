class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :facebook_id, :limit => 5
      t.text :gcm_registration_key
      t.string :android_id
      t.text :access_token
      t.integer :gender
      t.date :birthday
      t.timestamps
    end
    add_index :users, :android_id, :name => :users_idx, :unique => true
  end
end
