class BuildArtistLastfmJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :lastfm

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 5 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 1, :period => 1.second }
  })

  def perform(artist_id)
    return unless ENV['lastfm_key']

    artist = Artist.find artist_id

    lastfm = Lastfm.new(ENV['lastfm_key'], ENV['lastfm_secret'])

    begin
      lastfm_artist = lastfm.artist.get_info(artist:artist.name)
    rescue Lastfm::ApiError => e
    end

    if lastfm_artist.present?

      if lastfm_artist['tags'].present?
        skip_tags = ['all', 'seen live']

        lastfm_genre = lastfm_artist['tags']['tag'].map {|x| x.values.first}
        lastfm_genre = lastfm_genre.map(&:downcase)
        lastfm_genre = lastfm_genre.each.reject{|x| skip_tags.each.include? x}

        all_genres = artist.genres.to_set
        all_genres = all_genres.merge(lastfm_genre)

        artist.genres = all_genres
      end

      artist.external_lastfm = lastfm_artist['url']
      artist.lastfm_image = lastfm_artist['image'].last['content']
      artist.lastfm_stats_listeners = lastfm_artist['stats']['listeners'].to_i
      artist.lastfm_stats_playcount = lastfm_artist['stats']['playcount'].to_i
      artist.lastfm_bio = lastfm_artist['bio']['content']
      artist.lastfm_last_updated_at = Time.now

      artist.save
    end
  end
end