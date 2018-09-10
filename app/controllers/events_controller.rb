class EventsController < ApplicationController
  def index
    @events = Event.within(150, origin: current_user.location).includes(:artist).where(artist_id: Follow.select(:artist_id).where(user_id: current_user.id, active: true)).order('starts_at asc').where('starts_at >= ?', Date.today)
  end
end
