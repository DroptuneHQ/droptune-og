class AddMusicBrainzToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :musicbrainz_last_updated_at, :datetime
  end
end
