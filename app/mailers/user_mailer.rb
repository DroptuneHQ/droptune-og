class UserMailer < ApplicationMailer
  helper AlbumsHelper
  def welcome_email
    @user = params[:user]
    @url  = 'https://droptune.co'
    mail(to: @user.email, subject: 'Welcome to Droptune!')
  end

  def weekly_report(user_id)
    @user = User.find user_id

    # Albums from past 7 days
    @new_albums = Album.includes(:artist)
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .default_order.recent_releases(21).limit(9)

    # Upcoming albums
    @upcoming_albums = Album.includes(:artist)
      .future_releases
      .followed_by_user(@user)
      .filters_for_user(@user)
      .types_for_user(@user)
      .order('release_date asc', 'artists.name asc')
      .limit(9)

    if @new_albums.present? || @upcoming_albums.present?
      mail(to: @user.email, subject: "Droptune New Music: #{Date.today.strftime('%b %-d, %Y')}")
    end
  end
end
