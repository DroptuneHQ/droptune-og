class AddLastfmToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :lastfm_last_updated_at, :datetime
    add_column :artists, :external_lastfm, :string
    add_column :artists, :lastfm_image, :string
    add_column :artists, :lastfm_stats_listeners, :integer
    add_column :artists, :lastfm_stats_playcount, :integer
    add_column :artists, :lastfm_bio, :text
  end
end
