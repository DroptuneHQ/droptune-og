class NewsJob
  include Sidekiq::Worker

  sidekiq_options :queue => :default

  def perform
    url = "http://www.rssmix.com/u/8295443/rss.xml"
    xml = HTTParty.get(url).body
    feed = Feedjira::Feed.parse(xml)
    
    Artist.find_each do |artist|
      articles = feed.entries.select { |entry| entry.title.include?(artist.name) }
      articles.each do |article|
        og = OpenGraph.new(article.entry_id)
        image = og.images.first if og.present? and og.images.present?
        sitename = og.metadata[:site_name].first[:_value] if og.present? and og.metadata[:site_name].present?

        news_item = News.where('artist_id = ? AND url = ?', artist.id, article.entry_id).first_or_create(
              artist_id: artist.id, 
              title: article.title,
              summary: article.summary,
              image_url: image,
              url: article.entry_id,
              source_name: sitename,
              published_at: DateTime.parse(article.published.to_s))
        article.title
      end
    end
    
  end
end
