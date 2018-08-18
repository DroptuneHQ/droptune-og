class Album < ApplicationRecord
  belongs_to :artist

  scope :has_release_date, -> { where.not(release_date: nil) }
  scope :active, -> {where('follows.active = ?', true)}

  def to_param
    "#{id}-#{permalink}"
  end

private
  def permalink
    "#{self.artist.name.parameterize}-#{name.parameterize}"
  end
end