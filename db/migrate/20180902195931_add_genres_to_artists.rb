class AddGenresToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :genres, :jsonb, null: false, default: {}
    add_index :artists, :genres, using: :gin
  end
end
