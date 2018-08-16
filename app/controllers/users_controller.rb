class UsersController < ApplicationController

  def index
    @users = User.all  
  end

  def show
    @user = User.find(params[:id])
    @new_albums = @user.albums.active.has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').uniq.first(12)
  end
end
