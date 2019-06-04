class UpdateRecentlyStreamedJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    User.find_each do |user|
      RecentlyStreamedSpotifyJob.perform_async(user.id) if user.connections.spotify.present?
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Recently Streamed', cron: '0 */2 * * *', class: 'UpdateRecentlyStreamedJob')