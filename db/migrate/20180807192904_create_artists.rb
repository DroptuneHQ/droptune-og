class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.text     :name
      t.text     :genre
      t.integer  :itunes_id
      t.text     :itunes_link
      t.text     :spotify_id
      t.integer  :spotify_followers
      t.integer  :spotify_popularity
      t.text     :spotify_image
      t.text     :spotify_link
      t.timestamps
    end
  end
end
