class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :gcm_registration_key, :null => false
      t.string :android_id, :null => false
      t.text :access_token, :null => false
      t.integer :gender, :null => false
      t.date :birthday, :null => false
      t.timestamps
    end
  end
end
