class AddLastfmTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lastfm_token, :string
  end
end
