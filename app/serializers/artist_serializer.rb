class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :genres, :year_started, :year_ended, :external_homepage, :external_twitter, :external_facebook, :external_instagram, :external_wikipedia, :external_youtube, :external_lastfm, :spotify_link, :spotify_id, :applemusic_id, :spotify_image, :lastfm_image, :spotify_followers, :spotify_popularity, :lastfm_stats_listeners, :lastfm_stats_playcount, :imvdb_last_updated_at, :musicbrainz_last_updated_at, :spotify_last_updated_at, :applemusic_last_updated_at, :lastfm_last_updated_at, :songkick_last_updated_at, :created_at, :updated_at

  has_many :albums
end
