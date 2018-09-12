class EventsController < ApplicationController
  def index
    if current_user and current_user.location.present?
      @location = current_user.location
    else 
      if Rails.env.development?
        @ip = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
      elsif request.headers["X-Forwarded-For"].present?
        @ip = request.headers["X-Forwarded-For"].split(', ').select {|ip| ip if IPAddr.new(ip).ipv6? }.pop
      else
        @ip = request.remote_ip
      end

      @loc = JSON.parse(Net::HTTP.get(URI.parse("http://api.ipstack.com/#{@ip}?access_key=#{ENV['ipstack_key']}")))

      @location = []
      @location.push(@loc['city'])
      @location.push(@loc['region_name'])
      @location.push(@loc['country_code'])
      @location = @location.reject(&:blank?).join(', ').to_s
    end

    begin
      distance = params[:distance] ? params[:distance].to_i : 100
      
      if current_user
        query = Event.within(distance, origin: @location).includes(:artist).where(artist_id: Follow.select(:artist_id).where(user_id: current_user.id, active: true)).order('starts_at asc').where('starts_at >= ?', Date.today)
      else
        query = Event.within(distance, origin: @location).includes(:artist).order('starts_at asc').where('starts_at >= ?', Date.today).limit(100)
      end
      
      days = params[:days] ? params[:days].to_i : 30
      query = query.where('starts_at <= ?', Date.today + days.days)

      @events = query
    rescue
      @events = nil
      redirect_back(fallback_location: events_path)
    end

  end
end
