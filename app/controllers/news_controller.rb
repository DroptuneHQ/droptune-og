class NewsController < ApplicationController
  def index
    @user = current_user

    if @user
      @news = @user.news.includes(:artist).order(published_at: :desc).limit(20)
    else
      @news = News.all.includes(:artist).order(published_at: :desc).limit(20)
    end
  end
end
