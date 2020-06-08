# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Framework
gem "rails", "~> 5.2.3"

# Data
gem "pg"
gem "storext"
gem "with_advisory_lock"
gem "will_paginate", "~> 3.1.0"
gem "textacular", "~> 5.0" # Full-text search in Postgres
gem "ar_lazy_preload"      # automagic preloading defeats most N+1 queries

# REST-API
gem "active_model_serializers"
gem 'jbuilder', '~> 2.5'

# Webserver
gem "puma"
gem "puma_worker_killer"

# Frontend
gem "sass-rails", "~> 5.0" # Use SCSS for stylesheets
gem "uglifier", ">= 1.3.0" # Use Uglifier as compressor for JavaScript assets
gem "jquery-rails"
gem "coffee-rails", "~> 4.2"
gem "turbolinks", "~> 5"
gem "rails_admin", "~> 1.3"
gem 'rack-cors'
gem "browser"

# User Authentication
gem "devise"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"
gem "omniauth-spotify"

# Music Services
gem "rspotify"
gem "feedjira"          # A feed fetching and parsing library
gem "opengraph_parser"  # library for parsing Open Graph Protocol information from a website
gem 'musicbrainz'

# Background Processing
gem "sidekiq"
gem "sidekiq-throttled"
gem "sidekiq-cron"
gem "sidekiq-unique-jobs"
gem "sidekiq-failures"

# Stats/Error Reporting
gem "barnes"            # report GC usage data to statsd
gem "scout_apm"         # Monitors Ruby apps and reports detailed metrics on performance to Scout.
gem "sentry-raven"      # report errors to Sentry

# Caching
gem "redis"
gem "dalli"
gem "memcachier"

# Misc
gem "figaro"            # environment variables
gem "faker"
gem "httparty"
gem "jwt"
gem "colorize"          # ability to colorize output strings
gem 'dotenv-rails'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "annotate", require: false
  gem "better_errors"
  gem "binding_of_caller"
  # gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "letter_opener"
  gem "foreman", require: false
  gem "bundleup", require: false
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rails_config", require: false
  gem "rails_refactor"    # Specifically using to rename controllers
end

group :test do
  gem "capybara", ">= 2.15", "< 4.0"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
