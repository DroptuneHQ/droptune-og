class PagesController < ApplicationController
  def index
    @follows = Follow.group('artist_id').order('count_id desc').count('id').first(250).map(&:first)

    @albums = Album.includes(:artist).where(artist_id: @follows).has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').where.not(album_type: 'single').where("release_date <= ?", Date.today).limit(12)

    query = MusicVideo.includes(:artist).order(release_date: :desc, artist_id: :desc)
    @num_days = params[:days].present? ? params[:days].to_i : 90
    @videos = query.where("release_date <= ? AND release_date > ?", Date.today, @num_days.days.ago).uniq.first(12)
  end

  def test
    render :layout => false
  end

  def feed
    @user = User.find_by_username(params[:screename])

    @latest = Album.includes(:artist)
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .default_order
      .recent_releases(30).limit(90)

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def token
    @token = ENV['apple_token']

    # Hacky. Force token refresh.
    if current_user.present?
      connection = current_user.connections.where(provider:'spotify').first
      rspotify_user = RSpotify::User.new(connection.settings.to_hash)
      rspotify_user.top_tracks(limit: 1, offset: 0, time_range: 'short_term')
      connection.settings = rspotify_user.to_hash
      connection.save
      @spotify_user_token = current_user.connections.spotify.first.settings['credentials']['token'] 
    end

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
