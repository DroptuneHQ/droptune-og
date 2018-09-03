class GenresController < ApplicationController
  def index
    genres = Artist.all.pluck(:genres).flatten.delete_if &:empty?
    output = Hash[genres.group_by {|x| x}.map {|k,v| [k,v.count]}].sort_by{|k,v| v}.to_h
    final = output.delete_if {|key, value| value < 20 }
  end
end
