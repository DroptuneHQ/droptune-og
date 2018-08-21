class NewsController < ApplicationController
  def index
    @user = current_user

    if @user
      @news = @user.news.active.includes(:artist).order(published_at: :desc).uniq.first(20)
    else
      @news = News.all.includes(:artist).order(published_at: :desc).uniq.first(20)
    end
  end
end
