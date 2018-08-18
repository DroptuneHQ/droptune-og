class BuildArtistMusicbrainzJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 2 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 5, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    musicbrainz = MusicBrainz::Client.new
    musicbrainz_artist = musicbrainz.artists(artist.name).first
    artist.update_attributes year_started: musicbrainz_artist.date_begin, year_ended: musicbrainz_artist.date_end
  end
end