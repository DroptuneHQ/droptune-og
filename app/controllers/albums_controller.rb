class AlbumsController < ApplicationController

  def index
    @user = current_user

    if @user
      query = @user.albums.has_release_date.order(release_date: :desc, artist_id: :desc)

      query = query.where.not(album_type: 'compilation') if !@user.settings['show_compilations']
      #query = query.where.not(album_type: 'single') if !@user.settings['show_singles']
    else
      query = Album.has_release_date.order(release_date: :desc, artist_id: :desc).where.not(album_type: 'compilation').where.not(album_type: 'single')
    end

    if params[:month] and params[:year]
      @albums = query.where("extract(month from release_date) = ? and extract(year from release_date) = ?", params[:month], params[:year]).uniq
    elsif params[:year]
      @albums = query.where("extract(year from release_date) = ?", params[:year]).uniq
    else
      @albums = query.uniq.first(20)
    end

    @months = query.where('release_date > ?', 6.months.ago).uniq.map { |album| [Date::MONTHNAMES[album.release_date.month], album.release_date.year].join(' ') }.each_with_object(Hash.new(0)) { |month_year, counts| counts[month_year] += 1 }
    @years = query.uniq.map { |album| album.release_date.year }.each_with_object(Hash.new(0)) { |month_year, counts| counts[month_year] += 1 }
  end

  def show
    @album = Album.find(params[:id])
  end
end
