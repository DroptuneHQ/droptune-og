class ApplicationController < ActionController::Base
  include ExceptionHandler
  before_action :set_raven_context

private
  def set_raven_context
    Raven.user_context(id: current_user.id, email: current_user.email, username: current_user.username, ip_address: request.ip) if current_user.present?
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
