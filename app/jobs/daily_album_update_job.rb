class DailyAlbumUpdateJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform(batch = 0)
    User.where("id % 4 = ?", batch).find_each do |user|
      FollowSpotifyJob.perform_async(user.id)
      BuildPlaylistJob.perform_async(user.id)
    end
    
    Artist.where("id % 4 = ?", batch).find_each do |artist|
      BuildArtistJob.perform_async(artist.id)
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Daily update 1', cron: '0 0 * * *', class: 'DailyAlbumUpdateJob', args: 0)
# Sidekiq::Cron::Job.create(name: 'Daily update 2', cron: '0 6 * * *', class: 'DailyAlbumUpdateJob', args: 1)
# Sidekiq::Cron::Job.create(name: 'Daily update 3', cron: '0 12 * * *', class: 'DailyAlbumUpdateJob', args: 2)
# Sidekiq::Cron::Job.create(name: 'Daily update 4', cron: '0 18 * * *', class: 'DailyAlbumUpdateJob', args: 3)