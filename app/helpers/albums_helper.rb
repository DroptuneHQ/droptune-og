module AlbumsHelper
  def album_image(a)
    if a.spotify_image
      a.spotify_image
    elsif a.artwork_link
      a.artwork_link
    end
  end
end
