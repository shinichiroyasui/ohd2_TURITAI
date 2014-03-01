class CreateUserDestinyScores < ActiveRecord::Migration
  def change
    create_table :user_destiny_scores do |t|
      t.integer :user1_id, :null => false
      t.integer :user2_id, :null => false
      t.decimal  :score, :null => false
      t.timestamps
    end
    add_index :user_destiny_scores, [:user1_id, :user2_id], :name => :user_destiny_scores_idx, :unique => true
  end
end
