class AddLastUpdatedServiceToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :imvdb_last_updated_at, :datetime
    add_column :artists, :musicbrainz_last_updated_at, :datetime
    add_column :artists, :spotify_last_updated_at, :datetime
    add_column :artists, :applemusic_last_updated_at, :datetime
    add_index :artists, :imvdb_last_updated_at
    add_index :artists, :musicbrainz_last_updated_at
    add_index :artists, :spotify_last_updated_at
    add_index :artists, :applemusic_last_updated_at
  end
end
