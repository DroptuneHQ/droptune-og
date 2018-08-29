class BuildPlaylistJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform(user_id)
    user = User.find user_id

    # SPOTIFY
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

    # APPLE MUSIC
    if user.generate_playlist_applemusic.present? and user.apple_music_token.present?
      response = HTTParty.get('https://api.music.apple.com/v1/me/library/playlists', {
        query: {limit: 100 },
        headers: {"Authorization" => "Bearer #{ENV['apple_token']}", "music-user-token" => user.apple_music_token}
      })

      results = response.parsed_response['data']
      dt_playlist = results.select{|key| key['attributes']['name'] == 'Droptune New Music'}

      if dt_playlist.present?
        #playlist = RSpotify::Playlist.find(spotify.id, dt_playlist.first.id)
        #playlist.remove_tracks!(playlist.tracks)
      else
        playlist = HTTParty.post('https://api.music.apple.com/v1/me/library/playlists', {
          body: {attributes: { name: 'Droptune New Music', description: 'New music from Droptune'}}.to_json,
          headers: {'Content-Type' => 'application/json', "Authorization" => "Bearer #{ENV['apple_token']}", "music-user-token" => user.apple_music_token}
        })
        playlist_id = playlist.parsed_response['data'].first['id']
      end

      query = Album.includes(:artist).has_release_date.where(artist_id: Follow.select(:artist_id).where(user_id: user.id, active: true)).order(release_date: :desc).where.not(applemusic_id: nil)
      query = query.where.not(album_type: 'compilation') if !user.settings['show_compilations']
      query = query.where.not(album_type: 'single') if !user.settings['show_singles']
      albums = query.where("release_date <= ? AND release_date > ?", Date.today, 7.days.ago).uniq

      playlist_tracks = HTTParty.get("https://api.music.apple.com/v1/me/library/playlists/#{playlist_id}/tracks", {
          query: {limit: 100 },
          headers: {'Content-Type' => 'application/json', "Authorization" => "Bearer #{ENV['apple_token']}", "music-user-token" => user.apple_music_token}
        })
      playlist_tracks_data = playlist_tracks.parsed_response['data']
      playlist_track_names = playlist_tracks_data.map{|i| i["attributes"]["name"]}


      albums.each do |album|
        album_tracks = HTTParty.get("https://api.music.apple.com/v1/catalog/us/albums/#{album.applemusic_id}/tracks", {
          query: {limit: 100 },
          headers: {"Authorization" => "Bearer #{ENV['apple_token']}"}
        })

        tracks_response = album_tracks.parsed_response['data']

        # TODO: Only add new tracks

        HTTParty.post("https://api.music.apple.com/v1/me/library/playlists/#{playlist_id}/tracks", 
          body: {data: tracks_response}.to_json,
          headers: {
            'Content-Type' => 'application/json', 
            "Authorization" => "Bearer #{ENV['apple_token']}", 
            "music-user-token" => user.apple_music_token
          }
        )
      end
    end
    
  end
end
