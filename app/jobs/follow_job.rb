class FollowJob < ApplicationJob
  queue_as :default

  def perform(id)
    user = User.find id
    connection = user.connections.where(provider:'spotify').first.settings.to_hash
    spotify_user = RSpotify::User.new(connection)
    user.save

    spotify = spotify_user

    # Saved Tracks
    (0..100000000000).step(50) do |n|
      artist_ids = Array.new
      tracks = spotify.saved_tracks(limit: 50, offset: n)
      break if tracks.size == 0
      tracks.each do |track|
        track.artists.each do |artist|
          artist_ids.push(artist.id)
        end
      end
      artist_ids = artist_ids.uniq.compact.each_slice(25).to_a
      artist_ids.each do |artist_group|
        ArtistJob.perform_later(user.id, artist_group)
      end
      sleep 0.3
    end

    # Playlists
    # spotify.playlists.each do |playlist|
    #   artist_ids = Array.new
    #   playlist.tracks.each do |track|
    #     track.artists.each do |artist|
    #       artist_ids.push(artist.id)
    #     end
    #   end
    #   artist_ids = artist_ids.uniq.compact.each_slice(25).to_a
    #   artist_ids.each do |artist_group|
    #     ArtistJob.perform_later(user.id, artist_group)
    #   end
    #   sleep 0.3
    # end
  end
end
