class Artist < ApplicationRecord
  has_many :albums
  has_many :music_videos
  has_many :news
  has_many :follows, dependent:  :destroy
  has_many :users, -> { distinct }, through: :follows

  scope :active, -> {where('follows.active = ?', true)}

  def to_param
    "#{id}-#{permalink}"
  end

private
  def permalink
    "#{name.parameterize}"
  end
end