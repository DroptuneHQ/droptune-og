class BuildArtistApplemusicJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :artists

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 10 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 8, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id

    response = HTTParty.get('https://api.music.apple.com/v1/catalog/us/search', {
      query: {term: artist.name, types: 'artists', limit: 1},
      headers: {"Authorization" => "Bearer #{ENV['apple_token']}"}
    })
    artist.update_attributes applemusic_id: response.parsed_response['results']['artists']['data'].first['id'] if response.parsed_response['results'].present?

    BuildAlbumApplemusicJob.perform_async(artist_id)
  end
end
