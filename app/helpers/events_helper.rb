module EventsHelper
  def time_wording(days)
    case days
    when "30"
      "Next month"
    when "90"
      "Next 3 months"
    when "180"
      "Next 6 months"
    else
      "Next month"
    end
  end

  def distance_wording(distance)
    distance = distance ? distance : 100
    
    "#{distance} mi"
  end

  def location_name(event)
    location = []
    location.push(event.city)
    location.push(event.region)
    location.push(event.country)

    location.reject(&:blank?).join(', ')
  end
end
