# == Schema Information
#
# Table name: follows
#
#  id         :bigint(8)        not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artist_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_follows_on_active     (active)
#  index_follows_on_artist_id  (artist_id)
#  index_follows_on_user_id    (user_id)
#

class Follow < ApplicationRecord
  belongs_to :artist
  belongs_to :user

  def unfollow
    self.update_attributes(active: false)
  end
end
