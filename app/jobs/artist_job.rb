class ArtistJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 2 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 5, :period => 5.seconds }
  })

  def perform(user_id, artist_ids)
    user = User.find user_id
    user.save

    artists = RSpotify::Artist.find(artist_ids)

    artists.each do |artist|
      Artist.with_advisory_lock(artist.id) do
        current_artist = Artist.find_or_create_by(name: artist.name)
        
        user.artists << current_artist unless Follow.where(user: user, artist: current_artist, active: false).present?

        image = artist.images.first['url'] if artist.images.present?

        current_artist.update_attributes spotify_id: artist.id, spotify_followers: artist.followers['total'], spotify_popularity: artist.popularity, spotify_image: image, spotify_link: artist.external_urls['spotify']

        AlbumJob.perform_async(current_artist.id) if current_artist.updated_at > 3.hours.ago or current_artist.updated_at < 1.day.ago
      end
    end

  end
end
