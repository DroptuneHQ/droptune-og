class AddConnectTimesToUserse < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :spotify_connected_at, :datetime
    add_column :users, :spotify_disconnected_at, :datetime
    add_column :users, :applemusic_connected_at, :datetime
    add_column :users, :applemusic_disconnected_at, :datetime
    add_column :users, :lastfm_connected_at, :datetime
    add_column :users, :lastfm_disconnected_at, :datetime
  end
end
