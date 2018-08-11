class ArtistJob < ApplicationJob
  queue_as :default

  def perform(user_id, artist_ids)
    user = User.find user_id
    user.save

    artists = RSpotify::Artist.find(artist_ids)

    artists.each do |artist|
      Artist.with_advisory_lock(artist.id) do
        current_artist = Artist.find_or_create_by(name: artist.name)
        user.artists << current_artist

        current_artist.update_attributes spotify_id: artist.id, spotify_followers: artist.followers['total'], spotify_popularity: artist.popularity, spotify_image: artist.images.first['url'], spotify_link: artist.external_urls['spotify']

        AlbumJob.set(wait: 30.seconds).perform_later(current_artist.id) if current_artist.updated_at > 1.minute.ago or current_artist.updated_at < 1.day.ago
      end
    end

  end
end
