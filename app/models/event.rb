# == Schema Information
#
# Table name: events
#
#  id                  :bigint(8)        not null, primary key
#  city                :string
#  country             :string
#  eventful_popularity :integer
#  eventful_ticket_url :string
#  eventful_url        :string
#  lat                 :decimal(15, 10)
#  lng                 :decimal(15, 10)
#  postal_code         :string
#  price               :decimal(, )
#  region              :string
#  songkick_popularity :decimal(15, 10)
#  songkick_ticket_url :string
#  songkick_url        :string
#  starts_at           :datetime
#  venue_address       :string
#  venue_name          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  artist_id           :bigint(8)
#  eventful_id         :string
#  songkick_id         :integer
#
# Indexes
#
#  index_events_on_artist_id  (artist_id)
#

class Event < ApplicationRecord
  belongs_to :artist
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng
end
