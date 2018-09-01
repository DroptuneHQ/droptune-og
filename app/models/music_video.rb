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
