class AddSocialToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :social_twitter, :string
    add_column :artists, :social_facebook, :string
    add_column :artists, :social_instagram, :string
  end
end
