class BuildPlaylistJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform(user_id)
    user = User.find user_id

    if user.generate_playlist_spotify.present? and user.connections.spotify.present?
      connection = user.connections.spotify.first.settings.to_hash
      spotify = RSpotify::User.new(connection)

      if user.generate_playlist_spotify_id.present?
        playlist = RSpotify::Playlist.find(spotify.id, user.generate_playlist_spotify_id)
      else
        playlist = spotify.create_playlist!('Droptune New Music')
        user.update_attributes(generate_playlist_spotify_id: playlist.id)
      end
    end
    
  end
end
