class UsersController < ApplicationController

  def index
    @users = User.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    @new_albums = @user.albums.active.has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').uniq.first(12)
  end

  def import_apple_music
    results = []
    offset = 0

    loop do
      url = URI("https://api.music.apple.com/v1/me/library/artists?limit=100&offset=#{offset}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["authorization"] = "Bearer #{params['dev_token']}"
      request["music-user-token"] = params['user_token']

      response = http.request(request)
      body = JSON.parse(response.body)
      next_url = body['next']

      results += body['data']

      break if (next_url.blank?)

      offset = offset+100
    end

    #puts results

    results.each do |result|
      puts result['attributes']['name']
    end
    
    # puts response.read_body
  end
end
