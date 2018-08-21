cache('sitemap-artists', expires_in: 12.hours) do
  base_url = "https://droptune.co/"

  xml.instruct! :xml, :version=>"1.0"
  xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
    xml.url do
      xml.loc artists_url
      xml.changefreq 'daily'
    end
    Artist.find_each do |artist|
      xml.url do
        xml.loc artist_url(artist)
        xml.lastmod artist.updated_at
      end
    end
  end
end