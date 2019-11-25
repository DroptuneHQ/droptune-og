class MaintenanceJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    # Kill duplicate follows
    Follow.select([:user_id,:artist_id]).group(:user_id,:artist_id).having("count(*) > 1").map.size.each do |follow|
      user_id = follow.first.first
      artist_id = follow.first.last
      follows = Follow.where(user_id: user_id, artist_id: artist_id).order('updated_at DESC')
      follows.last.destroy if follows.count > 1
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Maintenance', cron: '0 2 * * *', class: 'MaintenanceJob')