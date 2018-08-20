class MusicVideosController < ApplicationController
  def show
    @video = MusicVideo.find(params[:id])
  end
end
