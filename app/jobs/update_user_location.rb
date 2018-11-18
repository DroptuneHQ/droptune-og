class UpdateUserLocation
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform(user_id)
    user = User.find user_id
    if user.location.blank? && user.last_sign_in_ip.present?
      loc = Geokit::Geocoders::MultiGeocoder.geocode(user.last_sign_in_ip.to_s)
      
      location = []
      location.push(loc.city)
      location.push(loc.state)
      location.push(loc.country_code)

      user.update_attributes(location: location.reject(&:blank?).join(', '))
    end
  end
end