class AddLastfmToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lastfm_username, :string
    add_column :users, :lastfm_playcount, :integer
    add_column :users, :lastfm_country, :string
  end
end
