class AddIndexToTheThings < ActiveRecord::Migration[5.2]
  def change
    add_index :artists, :name
    add_index :albums, :album_type
    add_index :albums, :release_date
    add_index :follows, :active
  end
end
