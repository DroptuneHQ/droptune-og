class AddIndexToMusicVideos < ActiveRecord::Migration[5.2]
  def change
    add_index :music_videos, [:artist_id, :source_data]
  end
end
