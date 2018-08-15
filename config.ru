# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

require 'sidekiq/web'
require 'sidekiq-scheduler/web'