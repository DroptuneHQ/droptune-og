class UsersController < ApplicationController

  def index
    redirect_to root_path
  end

  def show
    redirect_to edit_user_registration_path
  end

  def import_apple_music
    current_user.update_attributes(applemusic_connected_at: DateTime.current, apple_music_token: params['user_token']) if params['user_token']

    results = []
    artists = []
    offset = 0

    loop do
      response = HTTParty.get('https://api.music.apple.com/v1/me/library/artists', {
        query: {limit: 100, offset: offset},
        headers: {"Authorization" => "Bearer #{params['dev_token']}", "Music-User-Token" => params['user_token']}
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
