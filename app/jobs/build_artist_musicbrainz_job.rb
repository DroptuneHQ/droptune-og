class BuildArtistMusicbrainzJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 10 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 8, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    musicbrainz = MusicBrainz::Client.new
    musicbrainz_artist = musicbrainz.artists(artist.name).first

    if musicbrainz_artist.present?
      musicbrainz_full_artist = musicbrainz.artist musicbrainz_artist.id, includes: 'url-rels'

      urls = musicbrainz_full_artist.urls
      external_homepage = urls.select{|key| key == 'official homepage'}['official homepage']
      external_twitter = Array.wrap(urls['social network']).select{|key| key.include?("twitter")}.try(:first) if urls['social network'].present?
      external_facebook = Array.wrap(urls['social network']).select{|key| key.include?("facebook")}.try(:first) if urls['social network'].present?
      external_instagram = Array.wrap(urls['social network']).select{|key| key.include?("instagram")}.try(:first) if urls['social network'].present?
      external_wikipedia = urls['wikipedia']
      external_youtube = Array.wrap(urls['youtube']).try(:first)

      artist.update_attributes(
        year_started: musicbrainz_artist.date_begin, 
        year_ended: musicbrainz_artist.try(:date_end),
        external_homepage: external_homepage, 
        external_twitter: external_twitter, 
        external_facebook: external_facebook, 
        external_instagram: external_instagram,
        external_wikipedia: external_wikipedia,
        external_youtube: external_youtube)
    end
  end
end