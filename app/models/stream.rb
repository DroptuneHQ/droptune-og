# == Schema Information
#
# Table name: streams
#
#  id          :bigint(8)        not null, primary key
#  listened_at :datetime
#  name        :string
#  source      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :bigint(8)
#  artist_id   :bigint(8)
#  user_id     :bigint(8)
#
# Indexes
#
#  index_streams_on_album_id   (album_id)
#  index_streams_on_artist_id  (artist_id)
#  index_streams_on_user_id    (user_id)
#

class Stream < ApplicationRecord
  belongs_to :artist
  belongs_to :album
  belongs_to :user
end
