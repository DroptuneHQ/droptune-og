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
