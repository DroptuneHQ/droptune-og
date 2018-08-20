class NewsJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    url = "http://www.rssmix.com/u/8295443/rss.xml"
    xml = HTTParty.get(url).body
    feed = Feedjira::Feed.parse(xml)
    
    items = []
    Artist.find_each do |artist|
      puts artist.name
      articles = feed.entries.select { |entry| entry.title.include?(artist.name) }
      articles.each do |article|
        puts article.title
      end
    end
    
  end
end
