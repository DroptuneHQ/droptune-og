class RecentlyStreamedSpotifyJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 3 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 5, :period => 5.seconds }
  })

  def perform(user_id)
    user = User.find user_id

    if user.connections.where(provider:'spotify').present?
      connection = user.connections.where(provider:'spotify').first.settings.to_hash
      spotify = RSpotify::User.new(connection)

      begin
        recent_tracks = spotify.recently_played
      rescue RestClient::Forbidden => e
        # Disconnect if we don't have the right permissions
        connection = user.connections.where(provider:'spotify').first.destroy
      end

      if recent_tracks.present?
        recent_tracks.each do |track|
          artist_name = track.artists.first.name
          artist = Artist.where('lower(name) = ?', artist_name.downcase).first_or_initialize(name: artist_name)

          if artist.new_record?
            artist.save
            BuildArtistJob.perform_async(artist.id)
          end

          album_name = track.album.name
          album = Album.where('artist_id = ? AND lower(name) = ?', artist.id, album_name.downcase).first

          datetime = track.played_at.to_datetime
          stream = Stream.where('user_id = ? AND artist_id = ? AND listened_at = ?', user.id, artist.id, datetime)

          if stream.blank?
            stream = Stream.new
            stream.artist = artist
            stream.album = album
            stream.user = user
            stream.name = track.name
            stream.source = 'spotify'
            stream.listened_at = datetime
            stream.save
          end
        end
      end
      
    end

  end
end
