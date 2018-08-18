class UpdateArtistAttributes < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :applemusic_id, :string
    add_column :artists, :year_started, :int
    add_column :artists, :year_ended, :int
  end
end
