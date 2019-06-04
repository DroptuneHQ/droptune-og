class PurgeLastfm < ActiveRecord::Migration[5.2]
  def change
    remove_column :artists, :lastfm_last_updated_at, :datetime
    remove_column :artists, :external_lastfm, :string
    remove_column :artists, :lastfm_image, :string
    remove_column :artists, :lastfm_stats_listeners, :integer
    remove_column :artists, :lastfm_stats_playcount, :integer
    remove_column :artists, :lastfm_bio, :text

    remove_column :users, :lastfm_token, :string
    remove_column :users, :lastfm_username, :string
    remove_column :users, :lastfm_playcount, :integer
    remove_column :users, :lastfm_country, :string
    remove_column :users, :lastfm_connected_at, :datetime
    remove_column :users, :lastfm_disconnected_at, :datetime
  end
end
