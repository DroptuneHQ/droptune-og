module AlbumsHelper
  def album_image(a)
    if a.spotify_image
      a.spotify_image
    elsif a.applemusic_image
      a.applemusic_image.gsub('{w}','500').gsub('{h}','500')
    elsif a.artwork_link
      a.artwork_link
    end
  end
end
