# == Schema Information
#
# Table name: artists
#
#  id                          :bigint(8)        not null, primary key
#  applemusic_last_updated_at  :datetime
#  external_facebook           :string
#  external_homepage           :string
#  external_instagram          :string
#  external_lastfm             :string
#  external_twitter            :string
#  external_wikipedia          :string
#  external_youtube            :string
#  genres                      :jsonb            not null
#  imvdb_last_updated_at       :datetime
#  lastfm_bio                  :text
#  lastfm_image                :string
#  lastfm_last_updated_at      :datetime
#  lastfm_stats_listeners      :integer
#  lastfm_stats_playcount      :integer
#  musicbrainz_last_updated_at :datetime
#  name                        :text
#  songkick_last_updated_at    :datetime
#  spotify_followers           :integer
#  spotify_image               :text
#  spotify_last_updated_at     :datetime
#  spotify_link                :text
#  spotify_popularity          :integer
#  year_ended                  :integer
#  year_started                :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  applemusic_id               :string
#  spotify_id                  :text
#
# Indexes
#
#  index_artists_on_applemusic_last_updated_at   (applemusic_last_updated_at)
#  index_artists_on_genres                       (genres) USING gin
#  index_artists_on_imvdb_last_updated_at        (imvdb_last_updated_at)
#  index_artists_on_musicbrainz_last_updated_at  (musicbrainz_last_updated_at)
#  index_artists_on_name                         (name)
#  index_artists_on_spotify_last_updated_at      (spotify_last_updated_at)
#

class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :genres, :year_started, :year_ended, :external_homepage, :external_twitter, :external_facebook, :external_instagram, :external_wikipedia, :external_youtube, :external_lastfm, :spotify_link, :spotify_id, :applemusic_id, :spotify_image, :lastfm_image, :spotify_followers, :spotify_popularity, :lastfm_stats_listeners, :lastfm_stats_playcount, :imvdb_last_updated_at, :musicbrainz_last_updated_at, :spotify_last_updated_at, :applemusic_last_updated_at, :lastfm_last_updated_at, :songkick_last_updated_at, :created_at, :updated_at

  has_many :albums
end
