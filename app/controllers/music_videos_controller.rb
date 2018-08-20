class MusicVideosController < ApplicationController
  def index
    @user = current_user

    if @user
      query = @user.music_videos.includes(:artist).order(release_date: :desc, artist_id: :desc)
    else
      query = MusicVideo.includes(:artist).order(release_date: :desc, artist_id: :desc)
    end

    @num_days = params[:days].present? ? params[:days].to_i : 30
    @videos = query.where("release_date <= ? AND release_date > ?", Date.today, @num_days.days.ago).uniq  
  end
  def show
    @video = MusicVideo.find(params[:id])
  end
end
