class AddExpressionIndexesToAlbums < ActiveRecord::Migration[5.2]
  def change
    add_index :albums,
            'extract(year from release_date)',
            name: "index_on_albums_release_date_year"
    add_index :albums,
            'extract(month from release_date)',
            name: "index_on_albums_release_date_month"
  end
end
