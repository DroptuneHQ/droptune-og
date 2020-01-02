class BuildArtistMusicbrainzJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :musicbrainz

  sidekiq_throttle({
    :concurrency => { :limit => 5 },
    :threshold => { :limit => 1, :period => 1.second }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    musicbrainz_artist = MusicBrainz::Artist.find_by_name(artist.name)

    if musicbrainz_artist.present?
      urls = musicbrainz_artist.urls

      if urls[:social_network].present?
        external_twitter = Array.wrap(urls[:social_network]).select{|key| key.include?("twitter")}&.first
        external_facebook = Array.wrap(urls[:social_network]).select{|key| key.include?("facebook")}&.first
        external_instagram = Array.wrap(urls[:social_network]).select{|key| key.include?("instagram")}&.first
      end

      artist.update_attributes(
        social_twitter: external_twitter,
        social_facebook: external_facebook,
        social_instagram: external_instagram,
        musicbrainz_last_updated_at: Time.now
      )
    end
  end
end