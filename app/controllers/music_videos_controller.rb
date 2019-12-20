class MusicVideosController < ApplicationController
  respond_to :html, :json

  def index
    @user = current_user

    if @user
      query = @user.music_videos.active.includes(:artist).order(release_date: :desc, artist_id: :desc)
    else
      query = MusicVideo.includes(:artist).order(release_date: :desc, artist_id: :desc)
    end

    @num_days = params[:days].present? ? params[:days].to_i : 90
    @videos = query.where("release_date <= ? AND release_date > ?", Date.today, @num_days.days.ago).uniq

    respond_with @videos
  end

  def show
    begin
      @video = MusicVideo.find(params[:id])
    rescue ActiveRecord::RecordNotFound  
      redirect_to root_path
      return
    end
    
    respond_with @video
  end
end
