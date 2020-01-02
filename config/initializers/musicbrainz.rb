MusicBrainz.configure do |c|
  # Application identity (required)
  c.app_name = "Droptune"
  c.app_version = "1.0"
  c.contact = "hello@droptune.co"

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end