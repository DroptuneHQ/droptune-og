xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Droptune"
    xml.description "New music from Droptune"
    xml.link root_url

    @latest.each do |album|
      xml.item do
        xml.title "#{album.name} by #{album.artist.name}"
        xml.pubDate album.release_date.to_s(:rfc822)
        xml.link album_url(album)
        xml.guid album_url(album)
      end
    end
  end
end