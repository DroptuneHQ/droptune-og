class ArtistsController < ApplicationController
  def index
    @user = current_user

    if @user
      @artists = @user.artists.where.not(name: nil).order(name: :asc)
    else
      @artists = Artist.where.not(name: nil).order(name: :asc).limit(30)
    end
  end

  def show
    @artist = Artist.find(params[:id])
  end
end