class GenresController < ApplicationController
  def index
    genres = Artist.all.pluck(:genres).flatten.delete_if &:empty?
    output = Hash[genres.group_by {|x| x}.map {|k,v| [k,v.count]}].sort_by{|k,v| v}.to_h
    final = output.delete_if {|key, value| value < 35 }
    @keywords = final
  end

  def search
    @artists = Artist.basic_search(genres: params[:genre]).limit(100)
  end
end
