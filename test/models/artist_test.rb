# == Schema Information
#
# Table name: artists
#
#  id                          :bigint(8)        not null, primary key
#  applemusic_last_updated_at  :datetime
#  external_facebook           :string
#  external_homepage           :string
#  external_instagram          :string
#  external_twitter            :string
#  external_wikipedia          :string
#  external_youtube            :string
#  genres                      :jsonb            not null
#  imvdb_last_updated_at       :datetime
#  musicbrainz_last_updated_at :datetime
#  name                        :text
#  spotify_followers           :integer
#  spotify_image               :text
#  spotify_last_updated_at     :datetime
#  spotify_link                :text
#  spotify_popularity          :integer
#  year_ended                  :integer
#  year_started                :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  applemusic_id               :string
#  spotify_id                  :text
#
# Indexes
#
#  index_artists_on_applemusic_last_updated_at   (applemusic_last_updated_at)
#  index_artists_on_genres                       (genres) USING gin
#  index_artists_on_imvdb_last_updated_at        (imvdb_last_updated_at)
#  index_artists_on_musicbrainz_last_updated_at  (musicbrainz_last_updated_at)
#  index_artists_on_name                         (name)
#  index_artists_on_spotify_last_updated_at      (spotify_last_updated_at)
#

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
