class CreatePairscores < ActiveRecord::Migration
  def change
    create_table :pairscores do |t|

      t.timestamps
    end
  end
end
