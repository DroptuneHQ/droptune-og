class DailyAlbumUpdateJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    User.find_each do |user|
      FollowSpotifyJob.perform_async(user.id)
      BuildPlaylistJob.perform_async(user.id)
    end
    
    Artist.find_each do |artist|
      BuildArtistJob.perform_async(artist.id)
    end
  end
end
