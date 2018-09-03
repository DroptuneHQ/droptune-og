class GenresController < ApplicationController
  def index
    @keywords = Rails.cache.fetch("genre-cache", expires_in: 3.hours) do
      genres = Artist.all.pluck(:genres).flatten.delete_if &:empty?
      output = Hash[genres.group_by {|x| x}.map {|k,v| [k,v.count]}].sort_by{|k,v| v}.to_h
      output.delete_if {|key, value| value < 35 }
    end
  end

  def obscure
    @obscure_keywords = Rails.cache.fetch("obscure-genre-cache-v1", expires_in: 3.hours) do
      genres = Artist.all.pluck(:genres).flatten.delete_if &:empty?
      output = Hash[genres.group_by {|x| x}.map {|k,v| [k,v.count]}].sort_by{|k,v| v}.to_h
      output.delete_if {|key, value| value < 4 or value > 30 }
    end
  end

  def search
    @artists = Artist.basic_search(genres: params[:genre]).limit(100)
  end

  def show
    @user = User.find(params[:id])

    @keywords = Rails.cache.fetch("#{@user.username}-genre-cache", expires_in: 3.hours) do
      genres = @user.artists.pluck(:genres).flatten.delete_if &:empty?
      output = Hash[genres.group_by {|x| x}.map {|k,v| [k,v.count]}].sort_by{|k,v| v}.to_h
      output.delete_if {|key, value| value < 80 }
    end
  end
end
