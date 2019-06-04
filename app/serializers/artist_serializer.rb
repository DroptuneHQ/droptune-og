# == Schema Information
#
# Table name: artists
#
#  id                         :bigint(8)        not null, primary key
#  applemusic_last_updated_at :datetime
#  imvdb_last_updated_at      :datetime
#  name                       :text
#  spotify_followers          :integer
#  spotify_image              :text
#  spotify_last_updated_at    :datetime
#  spotify_link               :text
#  spotify_popularity         :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  applemusic_id              :string
#  spotify_id                 :text
#
# Indexes
#
#  index_artists_on_applemusic_last_updated_at  (applemusic_last_updated_at)
#  index_artists_on_imvdb_last_updated_at       (imvdb_last_updated_at)
#  index_artists_on_name                        (name)
#  index_artists_on_spotify_last_updated_at     (spotify_last_updated_at)
#

class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :spotify_link, :spotify_id, :applemusic_id, :spotify_image, :spotify_followers, :spotify_popularity, :imvdb_last_updated_at, :spotify_last_updated_at, :applemusic_last_updated_at, :created_at, :updated_at

  has_many :albums
  has_many :music_videos
end
