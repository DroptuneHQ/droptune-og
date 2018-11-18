class BuildAlbumApplemusicJob
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

    response = HTTParty.get("https://api.music.apple.com/v1/catalog/us/artists/#{artist.applemusic_id}/albums", {headers: {"Authorization" => "Bearer #{ENV['apple_token']}"}})

    albums = response.parsed_response['data']

    if albums.present?
      albums.each do |album|
        Album.with_advisory_lock("#{album['id']}") do
          details = album['attributes']
          album_name = details['name'].gsub(' - Single', '').gsub(' - EP', '')
          new_album = Album.where('artist_id = ? AND lower(name) = ?', artist.id, album_name.downcase).first_or_create(artist_id: artist.id, name: album_name)
          if details['isSingle'] == true
            album_type = 'single'
          else
            album_type = 'album'
          end

          new_album.update_attributes applemusic_id: album['id'], applemusic_image: details['artwork']['url'], applemusic_link: details['url'], album_type: album_type, release_date: details['releaseDate']
        end
      end
    end

  end
end
