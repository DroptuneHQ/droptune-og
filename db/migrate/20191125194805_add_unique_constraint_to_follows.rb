class AddUniqueConstraintToFollows < ActiveRecord::Migration[5.2]
  def change
    add_index :follows, [:user_id, :artist_id], unique: true
  end
end
