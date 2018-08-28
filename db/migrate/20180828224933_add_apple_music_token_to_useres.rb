class AddAppleMusicTokenToUseres < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apple_music_token, :text
  end
end
