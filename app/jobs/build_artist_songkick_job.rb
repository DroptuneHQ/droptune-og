class BuildArtistSongkickJob
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker
  
    sidekiq_options :queue => :songkick
  
    sidekiq_throttle({
      :concurrency => { :limit => 20 },
      :threshold => { :limit => 500, :period => 1.minute }
    })
  
    def perform(artist_id)
      artist = Artist.find artist_id
      
      Songkickr::Remote.base_uri 'https://api.songkick.com/api/3.0'
      songkick = Songkickr::Remote.new ENV['songkick_key']
      songkick_results = songkick.events(artist.name)
  
      if songkick_results.present? and songkick_results.total_entries > 0
        songkick_events = songkick_results.results

        songkick_events.each do |songkick_event|
          starts_at = songkick_event.start.to_datetime
          event = Event.where('artist_id = ? AND starts_at = ?', artist.id, starts_at)

          if event.blank?
            event = Event.new
            event.artist_id = artist.id
            #event.postal_code = album
            event.city = songkick_event.venue.metro_area.display_name
            event.region = songkick_event.venue.metro_area.state
            event.country = songkick_event.venue.metro_area.country
            event.lat = songkick_event.location.lat
            event.lng = songkick_event.location.lng
            event.starts_at = starts_at
            event.venue_name = songkick_event.venue.display_name
            #event.venue_address = datetime
            event.songkick_popularity = songkick_event.popularity
            event.songkick_id = songkick_event.id
            event.songkick_url = songkick_event.uri
            #event.songkick_ticket_url = datetime
            event.save
          end
        end
  
  
        artist.update_attributes(songkick_last_updated_at: Time.now)
      end
    end
  end