class RecentlyStreamedSpotifyJob
  include Sidekiq::Worker
  sidekiq_options :queue => :artists

  def perform(user_id)
    user = User.find user_id

    connection = user.connections.where(provider:'spotify').first.settings.to_hash
    spotify = RSpotify::User.new(connection)

    recent_tracks = spotify.recently_played

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
          album = Album.where('artist_id = ? AND lower(name) = ?', artist.id, album_name.downcase).first

          datetime = Time.at(track['date']['uts'].to_i).to_datetime
          stream = Stream.where('user_id = ? AND artist_id = ? AND listened_at = ?', user.id, artist.id, datetime)

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
