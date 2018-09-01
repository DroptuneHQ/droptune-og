class WeeklyReportJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    User.find_each do |user|
      if user.settings['weekly_report']
        UserMailer.delay.weekly_report(user.id)
      end
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'Weekly Report every Wednesday', cron: '0 9 * * 3', class: 'WeeklyReportJob')