class BuildArtistApplemusicJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options :queue => :applemusic

  sidekiq_throttle({
    :concurrency => { :limit => 20 },
    :threshold => { :limit => 100, :period => 1.minute }
  })

  def perform(artist_id)
    return unless ENV['apple_token']

    artist = Artist.find artist_id

    response = HTTParty.get('https://api.music.apple.com/v1/catalog/us/search', {
      query: {term: artist.name, types: 'artists', limit: 1},
      headers: {"Authorization" => "Bearer #{ENV['apple_token']}"}
    })

    if response.parsed_response['results'].present?
      artist.update_attributes(applemusic_id: response.parsed_response['results']['artists']['data'].first['id'], applemusic_last_updated_at: Time.now)

      BuildAlbumApplemusicJob.perform_async(artist_id)
    end
  end
end
