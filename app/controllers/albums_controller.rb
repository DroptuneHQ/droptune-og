class AlbumsController < ApplicationController

  def index
    @user = current_user

    if @user
      query = Album.includes(:artist).has_release_date.where.not(album_type: 'compilation').where(artist_id: Follow.select(:artist_id).where(user_id: @user.id, active: true)).order(release_date: :desc)

      #query = @user.albums.active.has_release_date.includes(:artist).order(release_date: :desc)
      #query = query.where.not(album_type: 'compilation') if !@user.settings['show_compilations']
    else
      query = Album.includes(:artist).has_release_date.includes(:artist).order(release_date: :desc).where.not(album_type: 'compilation').where.not(album_type: 'single')
    end

    if params[:month] and params[:year]
      @albums = query.where("extract(month from release_date) = ? and extract(year from release_date) = ?", params[:month], params[:year]).uniq
    elsif params[:year]
      @albums = query.where("extract(year from release_date) = ?", params[:year]).uniq
    else
      @num_days = params[:days].present? ? params[:days].to_i : 7
      @albums = query.where("release_date <= ? AND release_date > ?", Date.today, @num_days.days.ago).uniq
    end
  end

  def upcoming
    @user = current_user

    if @user
      query = Album.has_release_date.where.not(album_type: 'compilation').where("release_date > ?", Date.today).where(artist_id: Follow.select(:artist_id).where(user_id: @user.id, active: true)).order(release_date: :asc)

      #query = @user.albums.active.has_release_date.includes(:artist).where("release_date >= ?", Date.today).order(release_date: :asc)

      #query = query.where.not(album_type: 'compilation') if !@user.settings['show_compilations']
      #query = query.where.not(album_type: 'single') if !@user.settings['show_singles']
    else
      query = Album.has_release_date.includes(:artist).where("release_date > ?", Date.today).order(release_date: :asc).where.not(album_type: 'compilation').where.not(album_type: 'single').limit(24)
    end

    @albums = query.uniq
  end

  def show
    @album = Album.find(params[:id])
  end
end
