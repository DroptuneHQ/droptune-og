class CreateMusicVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :music_videos do |t|
      t.references :artist
      t.string :name
      t.date :release_date
      t.string :image
      t.string :source
      t.string :source_data
      t.timestamps
    end
  end
end
