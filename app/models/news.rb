class News < ApplicationRecord
  belongs_to :artist

  scope :active, -> {where('follows.active = ?', true)}

  def article_image
    if image_url.present?
      image_url
    else
      artist.spotify_image
    end
  end
end
