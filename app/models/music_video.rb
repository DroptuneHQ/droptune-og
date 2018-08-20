class MusicVideo < ApplicationRecord
  belongs_to :artist

  scope :active, -> {where('follows.active = ?', true)}

  def to_param
    "#{id}-#{permalink}"
  end

private
  def permalink
    "#{self.artist.name.parameterize}-#{name.parameterize}"
  end
end
