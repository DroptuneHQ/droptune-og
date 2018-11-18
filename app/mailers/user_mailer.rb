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
    new_query = Album.includes(:artist).has_release_date.where(artist_id: Follow.select(:artist_id).where(user_id: @user.id, active: true)).order(release_date: :desc)
    new_query = new_query.where.not(album_type: 'compilation') if !@user.settings['show_compilations']
    new_query = new_query.where.not(album_type: 'single') if !@user.settings['show_singles']
    @new_albums = new_query.where("release_date <= ? AND release_date > ?", Date.today, 7.days.ago).uniq.first(9)

    # Upcoming albums
    upcoming_query = Album.includes(:artist).has_release_date.where("release_date > ?", Date.today).where(artist_id: Follow.select(:artist_id).where(user_id: @user.id, active: true)).order(release_date: :asc)
    upcoming_query = upcoming_query.where.not(album_type: 'compilation') if !@user.settings['show_compilations']
    upcoming_query = upcoming_query.where.not(album_type: 'single') if !@user.settings['show_singles']
    @upcoming_albums = upcoming_query.uniq.first(9)

    if @new_albums.present? || @upcoming_albums.present?
      mail(to: @user.email, subject: "Droptune New Music: #{Date.today.strftime('%b %-d, %Y')}")
    end
  end
end
