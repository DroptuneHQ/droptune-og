class FollowArtistsJob
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(user_id, artist_names)
    user = User.find user_id
    artist_names = Array(artist_names)

    artist_names.each do |artist_name|
      artist = Artist.where('lower(name) = ?', artist_name.downcase).first_or_initialize(name: artist_name)

      if artist.new_record?
        artist.save
        BuildArtistJob.perform_async(artist.id)
      end
      
      begin
        user.artists << artist unless Follow.where(user: user, artist: artist, active: false).present?
      rescue ActiveRecord::RecordInvalid => invalid
      end
    end
  end
end
