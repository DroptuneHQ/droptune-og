class AddSlugsToAlbumsMusicVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :artist_slug, :string
    add_column :music_videos, :artist_slug, :string
    add_index :albums, :artist_slug
    add_index :music_videos, :artist_slug
  end
end
