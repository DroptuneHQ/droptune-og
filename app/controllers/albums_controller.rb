class AlbumsController < ApplicationController
  respond_to :html, :json

  def index
    @user = current_user

    @albums = Album.includes(:artist)
      .followed_by_user(@user)
      .types_for_user(@user)
      .default_order

    if params[:month] && params[:year]
      @albums = @albums.for_month(params[:month]).for_year(params[:year])
    elsif params[:year]
      @albums = @albums.for_year(params[:year])
    else
      @num_days = params.fetch(:days, 21).to_i

      @albums = @albums.recent_releases(@num_days)
    end

    respond_with(@albums) do |format|
      format.html { @albums }
      format.json { render json: @albums.paginate(:page => params[:page], :per_page => 25) }
    end
  end

  def upcoming
    @user = current_user

    @albums = Album.includes(:artist)
      .future_releases
      .followed_by_user(@user)
      .types_for_user(@user)
      .order('release_date asc', 'artists.name asc')

    respond_with @albums
  end

  def show
    @album = Album.find(params[:id])

    respond_with @album
  end
end
