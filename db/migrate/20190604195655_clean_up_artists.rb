class CleanUpArtists < ActiveRecord::Migration[5.2]
  def change
    remove_column :artists, :year_started, :integer
    remove_column :artists, :year_ended, :integer
    remove_column :artists, :external_homepage, :string
    remove_column :artists, :external_twitter, :string
    remove_column :artists, :external_facebook, :string
    remove_column :artists, :external_instagram, :string
    remove_column :artists, :external_wikipedia, :string
    remove_column :artists, :external_youtube, :string
    remove_column :artists, :musicbrainz_last_updated_at, :datetime
    remove_column :artists, :genres, :jsonb
  end
end
