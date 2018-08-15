class DailyAlbumUpdateJob
  include Sidekiq::Worker

  sidekiq_options :queue => :daily

  def perform
    User.find_each do |user|
      FollowJob.perform_async(user.id)
    end
  end
end
