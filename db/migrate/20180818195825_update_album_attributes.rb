class UpdateAlbumAttributes < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :applemusic_id, :bigint
    add_column :albums, :applemusic_image, :string
    add_column :albums, :applemusic_link, :string
  end
end
