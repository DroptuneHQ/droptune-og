class RecentlyStreamedLastfmJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :lastfm

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 5 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 1, :period => 1.second }
  })

  def perform(user_id)
    user = User.find user_id
    
    if user.lastfm_token.present?
      lastfm = Lastfm.new(ENV['lastfm_key'], ENV['lastfm_secret'])
      lastfm.session = user.lastfm_token
      recent_tracks = lastfm.user.get_recent_tracks(user: user.lastfm_username, limit: 200)

      recent_tracks.each do |track|
        unless track['nowplaying'].present?
          artist_name = track['artist']['content']
          artist = Artist.where('lower(name) = ?', artist_name.downcase).first_or_initialize(name: artist_name)

          if artist.new_record?
            artist.save
            BuildArtistJob.perform_async(artist.id)
          end

          album_name = track['album']['content']
          if album_name.present?
            album = Album.where('artist_id = ? AND lower(name) = ?', artist.id, album_name.downcase).first

            datetime = Time.at(track['date']['uts'].to_i).to_datetime
            stream = Stream.where(user: user, artist: artist, listened_at: datetime)

            if stream.blank?
              stream = Stream.new
              stream.artist = artist
              stream.album = album
              stream.user = user
              stream.name = track['name']
              stream.source = 'lastfm'
              stream.listened_at = datetime
              stream.save
            end
          end
        end
      end
    end

  end
end
