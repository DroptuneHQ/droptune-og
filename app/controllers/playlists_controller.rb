class PlaylistsController < ApplicationController
  def index
    
  end

  def enable
    @user = current_user

    if params[:service] == 'spotify'
      @user.update_attributes(generate_playlist_spotify: true)
      BuildPlaylistJob.perform_async(@user.id)
    elsif params[:service] == 'applemusic'
      @user.update_attributes(generate_playlist_applemusic: true)
      BuildPlaylistJob.perform_async(@user.id)
    end

    redirect_to playlists_path
  end

  def disable
    @user = current_user

    if params[:service] == 'spotify'
      @user.update_attributes(generate_playlist_spotify: false)
    elsif params[:service] == 'applemusic'
      @user.update_attributes(generate_playlist_applemusic: false)
    end

    redirect_to playlists_path
  end
end
