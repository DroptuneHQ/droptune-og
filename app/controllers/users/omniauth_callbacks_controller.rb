class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Twitter. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end 
  end

  def spotify
    @user = current_user

    if @user
      auth = request.env["omniauth.auth"]
      spotify_user = RSpotify::User.new(auth).to_hash
      connection = Connection.where(:provider => auth['provider'], :uid => auth['uid'].to_s).first 

      if connection
        connection.settings = spotify_user
        connection.save
      else
        connection = current_user.connections.create(provider: auth['provider'], uid: auth['uid'].to_s, settings: spotify_user)
      end
    end
  end

  def apple
    
  end

  def failure
    redirect_to root_path
  end
end