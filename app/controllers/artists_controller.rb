class ArtistsController < ApplicationController
  respond_to :html, :json

  def index
    @user = current_user

    if @user
      @artists = @user.artists.active.where.not(name: nil).order("lower(artists.name) ASC").limit(5).uniq
    else
      @artists = Artist.where.not(name: nil).order(name: :asc).limit(30).uniq
    end

    respond_with @artists
  end

  def show
    @artist = Artist.find(params[:id])

    respond_with @artist
  end

  def follow
    @artist = Artist.find(params[:id])
    
    current_user.follows.where(artist: @artist).delete_all
    current_user.artists << @artist

    if request.xhr?
      render json: { 
        artist: render_to_string('artists/_follow', 
          layout: false, locals: { artist: @artist }
        )
      }
    else
      redirect_to artist_path(@artist)
    end
  end

  def unfollow
    @artist = Artist.find(params[:id])
    
    current_user.follows.where(artist: @artist).delete_all
    current_user.follows.create(artist: @artist, active: false)

    if request.xhr?
      render json: { 
        artist: render_to_string('artists/_follow', 
          layout: false, locals: { artist: @artist }
        )
      }
    else
      redirect_to artist_path(@artist)
    end
  end

  def search
    @artists = Artist.basic_search(name: params[:artist]).left_joins(:follows).group(:id).reorder('COUNT(follows.artist_id) DESC').limit(50)
  end
end