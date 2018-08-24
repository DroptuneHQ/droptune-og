class UsersController < ApplicationController

  def index
    @users = User.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    #@new_albums = @user.albums.active.has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').uniq.first(12)
  end

  def import_apple_music
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
end
