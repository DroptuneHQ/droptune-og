class UsersController < ApplicationController

  def index
    @users = User.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])

    @new_albums = Album.includes(:artist).has_release_date.where.not(album_type: 'compilation').where(artist_id: Follow.select(:artist_id).where(user_id: @user.id, active: true)).limit(12).order(release_date: :desc).where("release_date <= ?", Date.today).uniq
  end

  def import_apple_music
    current_user.update_attributes(applemusic_connected_at: DateTime.current, apple_music_token: params['user_token']) if params['user_token']

    results = []
    artists = []
    offset = 0

    loop do
      response = HTTParty.get('https://api.music.apple.com/v1/me/library/artists', {
        query: {limit: 100, offset: offset},
        headers: {"Authorization" => "Bearer #{params['dev_token']}", "music-user-token" => params['user_token']}
      })
      
      next_url = response.parsed_response['next']

      results += response.parsed_response['data']

      break if (next_url.blank?)

      offset = offset+100
    end

    results.each do |result|
      artists.push(result['attributes']['name'])
    end

    FollowArtistsJob.perform_async(current_user.id, artists)
  end

  def lastfm_callbacks
    lastfm = Lastfm.new(ENV['lastfm_key'], ENV['lastfm_secret'])
    token = params[:token]
    lastfm.session = lastfm.auth.get_session(token: token)['key']
    
    current_user.lastfm_token = lastfm.session
    current_user.lastfm_username = lastfm.user.get_info['name']
    current_user.lastfm_playcount = lastfm.user.get_info['playcount'].to_i
    current_user.lastfm_country = lastfm.user.get_info['country']
    current_user.lastfm_connected_at = DateTime.current

    current_user.save

    flash[:notice] = 'Last.fm connected!'
    redirect_to root_path
  end
end
