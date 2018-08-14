class ChartsController < ApplicationController
  def index
    @follows = Follow.group('artist_id').order('count_id desc').count('id').to_a.first(18)
  end
end
