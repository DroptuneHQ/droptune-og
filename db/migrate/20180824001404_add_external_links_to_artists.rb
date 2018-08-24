class AddExternalLinksToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :external_homepage, :string
    add_column :artists, :external_twitter, :string
    add_column :artists, :external_facebook, :string
    add_column :artists, :external_instagram, :string
    add_column :artists, :external_wikipedia, :string
    add_column :artists, :external_youtube, :string
  end
end
