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
end
