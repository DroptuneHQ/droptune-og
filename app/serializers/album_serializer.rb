# == Schema Information
#
# Table name: albums
#
#  id                 :bigint(8)        not null, primary key
#  album_type         :string
#  applemusic_image   :string
#  applemusic_link    :string
#  artist_slug        :string
#  artwork_link       :text
#  name               :text
#  release_date       :date
#  spotify_image      :text
#  spotify_link       :text
#  spotify_popularity :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  applemusic_id      :bigint(8)
#  artist_id          :bigint(8)
#  spotify_id         :text
#
# Indexes
#
#  index_albums_on_album_type          (album_type)
#  index_albums_on_artist_id           (artist_id)
#  index_albums_on_artist_id_and_name  (artist_id,name)
#  index_albums_on_artist_slug         (artist_slug)
#  index_albums_on_name                (name)
#  index_albums_on_release_date        (release_date)
#  index_on_albums_release_date_month  (date_part('month'::text, release_date))
#  index_on_albums_release_date_year   (date_part('year'::text, release_date))
#

class AlbumSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :artwork_link,
    :release_date,
    :album_type,
    :spotify_id,
    :spotify_image,
    :spotify_link,
    :applemusic_id,
    :applemusic_image,
    :applemusic_link,
    :spotify_popularity,
    :created_at,
    :updated_at
end
