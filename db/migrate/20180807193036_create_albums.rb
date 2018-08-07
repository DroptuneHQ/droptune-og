class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.references  :artist
      t.text :name
      t.text :artwork_link
      t.boolean :explicity, default: false
      t.integer :track_count
      t.date :release_date
      t.integer :itunes_id
      t.text :itunes_link
      t.text :spotify_id
      t.text     :spotify_image
      t.text     :spotify_link
      t.integer  :spotify_popularity
      t.string   :album_type
      t.timestamps
    end
  end
end
