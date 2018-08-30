class BuildArtistJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(artist_id)
    artist = Artist.find artist_id

    # Spotify
    BuildArtistSpotifyJob.perform_async(artist_id) if artist.spotify_last_updated_at.blank? or artist.spotify_last_updated_at < 1.day.ago
    
    # Apple Music
    BuildArtistApplemusicJob.perform_async(artist_id) if artist.applemusic_last_updated_at.blank? or artist.applemusic_last_updated_at < 1.day.ago

    # MusicBrainz
    BuildArtistMusicbrainzJob.perform_async(artist_id) if artist.musicbrainz_last_updated_at.blank? or artist.musicbrainz_last_updated_at < 7.days.ago

    # IMVDb
    BuildArtistImvdbJob.perform_async(artist_id) if artist.imvdb_last_updated_at.blank? or artist.imvdb_last_updated_at < 2.days.ago
  end
end
