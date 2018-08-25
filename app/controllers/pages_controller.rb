class PagesController < ApplicationController
  def index
    @albums = Album.includes(:artist).has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').where.not(album_type: 'single').limit(18)
  end

  def test
    render :layout => false
  end

  def token
    @token = ENV['apple_token']
    render :layout => false
  end

  def sitemap
    respond_to do |format|
      format.xml
    end
  end

  def sitemap_albums
    @page = params[:p].to_i
    @cache_name = "sitemap-albums-#{@page}"
    @batch_size = 1000

    if @page == 0
      @start = 0
      @finish = 25000
    else
      @start = @page * 25000
      @finish = 25000 + (@page * 25000)
    end

    respond_to do |format|
      format.xml
    end
  end

  def sitemap_artists
    respond_to do |format|
      format.xml
    end
  end

  def sitemap_musicvideos
    respond_to do |format|
      format.xml
    end
  end

  def sitemap_pages
    respond_to do |format|
      format.xml
    end
  end
end
