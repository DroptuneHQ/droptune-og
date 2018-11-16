# == Schema Information
#
# Table name: music_videos
#
#  id           :bigint(8)        not null, primary key
#  artist_slug  :string
#  image        :string
#  name         :string
#  release_date :date
#  source       :string
#  source_data  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  artist_id    :bigint(8)
#
# Indexes
#
#  index_music_videos_on_artist_id                  (artist_id)
#  index_music_videos_on_artist_id_and_source_data  (artist_id,source_data)
#  index_music_videos_on_artist_slug                (artist_slug)
#

class MusicVideo < ApplicationRecord
  belongs_to :artist

  validates_uniqueness_of :source_data, scope: :artist_id

  scope :active, -> {where('follows.active = ?', true)}
  
  before_save :set_slug

  def to_param
    "#{id}-#{permalink}"
  end

private
  def set_slug
    self.artist_slug = self.artist.name.parameterize if artist_slug.blank?
  end
  
  def permalink
    "#{self.artist_slug.parameterize}-#{name.parameterize}"
  end
end
