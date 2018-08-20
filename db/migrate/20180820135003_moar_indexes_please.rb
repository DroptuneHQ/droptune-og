class MoarIndexesPlease < ActiveRecord::Migration[5.2]
  def change
    add_index :albums, [:artist_id, :name]
    add_index :albums, :name
    add_index :connections, :provider
  end
end
