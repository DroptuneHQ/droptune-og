class BuildArtistJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(artist_id)
    # Spotify
    BuildArtistSpotifyJob.perform_async(artist_id)
    
    # Apple Music
    BuildArtistApplemusicJob.perform_async(artist_id)

    # MusicBrainz
    BuildArtistMusicbrainzJob.perform_async(artist_id)
  end
end
