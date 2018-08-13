class PagesController < ApplicationController
  def index
    @albums = Album.has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').where.not(album_type: 'single').limit(18)
  end

  def test
    render :layout => false
  end
end
