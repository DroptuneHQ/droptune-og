class MusicVideo < ApplicationRecord
  belongs_to :artist

    def to_param
    "#{id}-#{permalink}"
  end

private
  def permalink
    "#{self.artist.name.parameterize}-#{name.parameterize}"
  end
end
