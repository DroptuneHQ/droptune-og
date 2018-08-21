cache('sitemap', expires_in: 12.hours) do
  base_url = "https://droptune.co/"

  xml.instruct! :xml, :version=>"1.0"
  xml.tag! 'sitemapindex', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
    xml.sitemap do
      xml.loc sitemap_albums_url
    end
    xml.sitemap do
      xml.loc sitemap_artists_url
    end
    xml.sitemap do
      xml.loc sitemap_musicvideos_url
    end
    xml.sitemap do
      xml.loc sitemap_pages_url
    end
  end
end