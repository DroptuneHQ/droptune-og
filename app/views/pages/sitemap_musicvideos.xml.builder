cache('sitemap-musicvideos', expires_in: 12.hours) do
  base_url = "https://droptune.co/"

  xml.instruct! :xml, :version=>"1.0"
  xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
    xml.url do
      xml.loc music_videos_url
      xml.changefreq 'daily'
    end
    MusicVideo.find_each do |video|
      xml.url do
        xml.loc music_video_url(video)
        xml.lastmod video.updated_at
      end
    end
  end
end