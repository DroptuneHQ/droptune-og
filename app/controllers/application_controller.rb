class ApplicationController < ActionController::Base
  include ExceptionHandler
  before_action :set_raven_context
  helper_method :mobile_app?

private
  def set_raven_context
    Raven.user_context(id: current_user.id, email: current_user.email, username: current_user.username, ip_address: request.ip) if current_user.present?
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def mobile_app?
    @mobile_app ||= request.user_agent.to_s.include?('Droptune - MobileApp')
  end

  def ios_mobile_app?
    @ios_mobile_app ||= mobile_app? && request.user_agent.to_s.include?('iOS')
  end

  def mobile_app_version
    @mobile_app_version ||= request.user_agent.to_s.split('version::').last || '0.1 Build(0)'
  end
end
