module AlbumsHelper
  def album_image(a, size = '300')
    if a.applemusic_image
      a.applemusic_image.gsub('{w}',size.to_s).gsub('{h}',size.to_s)
    elsif a.spotify_image
      a.spotify_image
    elsif a.artwork_link
      a.artwork_link
    end
  end
end
