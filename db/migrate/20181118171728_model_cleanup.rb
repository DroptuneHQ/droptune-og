class ModelCleanup < ActiveRecord::Migration[5.2]
  def change
    remove_column :albums, :explicity, :boolean 
    remove_column :albums, :track_count, :integer
    remove_column :albums, :itunes_id, :integer
    remove_column :albums, :itunes_link, :text

    remove_column :artists, :itunes_id, :integer
    remove_column :artists, :itunes_link, :text
    remove_column :artists, :genre, :text
  end
end
