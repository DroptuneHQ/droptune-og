class FollowSpotifyJob
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

    if user.connections.where(provider:'spotify').first
      connection = user.connections.where(provider:'spotify').first.settings.to_hash
      spotify = RSpotify::User.new(connection)
      artist_ids = Array.new
      
      (0..100000000000).step(50) do |n|
        tracks = spotify.saved_tracks(limit: 50, offset: n)
        break if tracks.size == 0
        tracks.each do |track|
          # Only pull the primary artist from the track
          artist_ids.push(track.artists.first.name)
        end
      end

      artist_ids = artist_ids.uniq.compact.each_slice(50).to_a
      artist_ids.each do |artist_group|
        FollowArtistsJob.perform_async(user.id, artist_group)
      end
    end
  end
end
