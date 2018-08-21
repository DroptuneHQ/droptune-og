cache('sitemap-albums', expires_in: 12.hours) do
  base_url = "https://droptune.co/"

  xml.instruct! :xml, :version=>"1.0"
  xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
    xml.url do
      xml.loc albums_url
      xml.changefreq 'daily'
    end
    xml.url do
      xml.loc upcoming_albums_url
      xml.changefreq 'daily'
    end
  
    Album.find_each do |album|
      xml.url do
        xml.loc album_url(album)
        xml.lastmod album.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
      end
    end
  end
end