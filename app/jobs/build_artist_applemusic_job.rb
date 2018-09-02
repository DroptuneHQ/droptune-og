class BuildArtistApplemusicJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :applemusic

  sidekiq_throttle({
    :concurrency => { :limit => 20 },
    :threshold => { :limit => 100, :period => 1.minute }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    response = HTTParty.get('https://api.music.apple.com/v1/catalog/us/search', {
      query: {term: artist.name, types: 'artists', limit: 1},
      headers: {"Authorization" => "Bearer #{ENV['apple_token']}"}
    })

    am_genre = response.parsed_response['results']['artists']['data'].first['attributes']['genreNames']
    am_genre = am_genre.map(&:downcase)

    all_genres = artist.genres.to_set
    all_genres = all_genres.merge(am_genre)

    artist.update_attributes(applemusic_id: response.parsed_response['results']['artists']['data'].first['id'], applemusic_last_updated_at: Time.now, genres: all_genres) if response.parsed_response['results'].present?

    BuildAlbumApplemusicJob.perform_async(artist_id)
  end
end
