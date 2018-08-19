class FollowArtistsJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(user_id, artist_names)
    user = User.find user_id
    artist_names = Array(artist_names)

    artist_names.each do |artist_name|
      artist = Artist.where(name: artist_name).first_or_initialize

      if artist.new_record?
        artist.save
        BuildArtistJob.perform_async(artist.id)
      end
      
      user.artists << artist unless Follow.where(user: user, artist: artist, active: false).present?
    end
  end
end
