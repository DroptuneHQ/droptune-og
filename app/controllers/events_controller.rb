class EventsController < ApplicationController
  def index
    if current_user
      @location = current_user.location
    else 
      if Rails.env.development?
        @ip = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
      elsif request.headers["X-Forwarded-For"].present?
        @ip = request.headers["X-Forwarded-For"].split(' ').first
      else
        @ip = request.remote_ip
      end

      @ip = @ip.squish

      loc = Geokit::Geocoders::MultiGeocoder.geocode(@ip.to_s)
      @location = []
      @location.push(loc.city)
      @location.push(loc.state)
      @location.push(loc.country_code)
      @location = @location.reject(&:blank?).join(', ').to_s
    end

    begin
      if current_user
        @events = Event.within(150, origin: @location).includes(:artist).where(artist_id: Follow.select(:artist_id).where(user_id: current_user.id, active: true)).order('starts_at asc').where('starts_at >= ?', Date.today)
      else
        @events = Event.within(150, origin: @location).includes(:artist).order('starts_at asc').where('starts_at >= ?', Date.today).limit(20)
      end
    rescue
      @events = nil
    end
  end
end
