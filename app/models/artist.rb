# == Schema Information
#
# Table name: artists
#
#  id                         :bigint(8)        not null, primary key
#  applemusic_last_updated_at :datetime
#  imvdb_last_updated_at      :datetime
#  name                       :text
#  spotify_followers          :integer
#  spotify_image              :text
#  spotify_last_updated_at    :datetime
#  spotify_link               :text
#  spotify_popularity         :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  applemusic_id              :string
#  spotify_id                 :text
#
# Indexes
#
#  index_artists_on_applemusic_last_updated_at  (applemusic_last_updated_at)
#  index_artists_on_imvdb_last_updated_at       (imvdb_last_updated_at)
#  index_artists_on_name                        (name)
#  index_artists_on_spotify_last_updated_at     (spotify_last_updated_at)
#

class Artist < ApplicationRecord
  has_many :albums
  has_many :music_videos
  has_many :follows, dependent:  :destroy
  has_many :users, through: :follows
  has_many :active_users, ->{ where(follows: { active: true } ) }, through: :follows, source: :user

  scope :active, -> {where('follows.active = ?', true)}
  scope :with_name, -> { where.not(name: [nil, ""]) }
  scope :followed_by, ->(user) { joins(:follows).where(follows: { user: user, active: true } ) if user.present? }

  def to_param
    "#{id}-#{permalink}"
  end



private
  def permalink
    "#{name.parameterize}"
  end
end
