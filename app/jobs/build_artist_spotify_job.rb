class BuildArtistSpotifyJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 5 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 5, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    spotify_artist = RSpotify::Artist.search(artist.name).first
    
    if spotify_artist.present?
      image = spotify_artist.images.first['url'] if spotify_artist.images.present?
      artist.update_attributes spotify_id: spotify_artist.id, spotify_followers: spotify_artist.followers['total'], spotify_popularity: spotify_artist.popularity, spotify_image: image, spotify_link: spotify_artist.external_urls['spotify']

      BuildAlbumSpotifyJob.perform_async(artist_id)
    end
  end
end
