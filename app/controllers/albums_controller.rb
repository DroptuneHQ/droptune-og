class AlbumsController < ApplicationController
  respond_to :html, :json

  def index
    @user = current_user

    @latest = Album.includes(:artist)
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .default_order

    if params[:month] && params[:year]
      @latest = @latest.for_month(params[:month]).for_year(params[:year])
    elsif params[:year]
      @latest = @latest.for_year(params[:year])
    else
      @num_days = params.fetch(:days, 21).to_i

      @latest = @latest.recent_releases(@num_days).limit(12)
    end

    @upcoming = Album.includes(:artist)
      .future_releases
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .order('release_date asc', 'artists.name asc')
      .limit(12)


    @videos = @user.music_videos.active.includes(:artist).order(release_date: :desc, artist_id: :desc).first(12)


    respond_with(@latest) do |format|
      format.html { @latest }
      format.json { render json: @latest.paginate(:page => params[:page], :per_page => 25) }
    end
  end

  def latest
    @user = current_user

    @albums = Album.includes(:artist)
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .default_order

    @num_days = params.fetch(:days, 60).to_i

    @albums = @albums.recent_releases(@num_days)

    respond_with @albums
  end

  def upcoming
    @user = current_user

    @albums = Album.includes(:artist)
      .future_releases
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .order('release_date asc', 'artists.name asc')

    respond_with @albums
  end

  def show
    @album = Album.find(params[:id])

    respond_with @album
  end
end
