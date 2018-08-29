class BuildPlaylistJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform(user_id)
    user = User.find user_id

    if user.generate_playlist_spotify.present? and user.connections.spotify.present?
      connection = user.connections.spotify.first.settings.to_hash
      spotify = RSpotify::User.new(connection)

      playlists = spotify.playlists(limit:50)
      dt_playlist = playlists.select{|key| key.name == 'Droptune New Music'}

      if dt_playlist.present?
        playlist = RSpotify::Playlist.find(spotify.id, dt_playlist.first.id)
        playlist.remove_tracks!(playlist.tracks)
      else
        playlist = spotify.create_playlist!('Droptune New Music')
        user.update_attributes(generate_playlist_spotify_id: playlist.id)
      end

      query = Album.includes(:artist).has_release_date.where(artist_id: Follow.select(:artist_id).where(user_id: user.id, active: true)).order(release_date: :desc).where.not(spotify_id: nil)
      query = query.where.not(album_type: 'compilation') if !user.settings['show_compilations']
      query = query.where.not(album_type: 'single') if !user.settings['show_singles']
      albums = query.where("release_date <= ? AND release_date > ?", Date.today, 7.days.ago).uniq

      albums.each do |album|
        spotify_album = RSpotify::Album.find(album.spotify_id)
        tracks = spotify_album.tracks
        playlist.add_tracks!(tracks)
      end
    end
    
  end
end
