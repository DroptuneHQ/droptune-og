class AlbumJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  
  sidekiq_options :queue => :albums

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 2 },
    # Allow maximum 1K jobs being processed within one hour window.
    :threshold => { :limit => 5, :period => 5.seconds }
  })

  def perform(artist_id)
    artist = Artist.find artist_id
    albums = RSpotify::Artist.find(artist.spotify_id).albums(limit:50, album_type: 'album,single')

    albums.each do |album|  
      Album.with_advisory_lock("#{album.id}") do
        albums.each do |album|
          new_album = Album.where('artist_id = ? AND lower(name) = ?', artist.id, album.name.downcase).first_or_create(artist_id: artist.id, name: album.name)
          if album.artists.present? && album.artists.first.name == 'Various Artists'
            album_type = 'compilation'
          else
            album_type = album.album_type
          end

          new_album.update_attributes spotify_id: album.id, spotify_image: album.images.first['url'], spotify_link: album.external_urls['spotify'], spotify_popularity: album.popularity, album_type: album_type

          if new_album.release_date.blank? and album.try(:release_date)
            if album.release_date_precision == 'year'
              date = Date.strptime("#{album.release_date}-01-01", '%Y-%m-%d')
            elsif album.release_date_precision == 'month'
              date = Date.strptime("#{album.release_date}-01", '%Y-%m-%d')
            else
              date = album.release_date.to_date
            end
            new_album.update_attribute(:release_date, date)
          end
        end
      end
    end
  end
end
