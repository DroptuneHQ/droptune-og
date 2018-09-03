class UpdateRecentlyStreamedJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    User.where.not(lastfm_token: nil).find_each do |user|
      RecentlyStreamedJob.perform_async(user.id)
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Recently Streamed', cron: '0 */2 * * *', class: 'UpdateRecentlyStreamedJob')