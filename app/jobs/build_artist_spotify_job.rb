class BuildArtistSpotifyJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 3 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 3, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    spotify_artist = RSpotify::Artist.search(artist.name).first
    
    if spotify_artist.present?
      image = spotify_artist.images.first['url'] if spotify_artist.images.present?

      spotify_genres = spotify_artist.genres.map(&:downcase)

      all_genres = artist.genres.to_set
      all_genres = all_genres.merge(spotify_genres)

      artist.update_attributes spotify_id: spotify_artist.id, spotify_followers: spotify_artist.followers['total'], spotify_popularity: spotify_artist.popularity, spotify_image: image, spotify_link: spotify_artist.external_urls['spotify'], spotify_last_updated_at: Time.now, genres: all_genres

      BuildAlbumSpotifyJob.perform_async(artist_id)
    end
  end
end
