class ApplicationController < ActionController::Base
  include ExceptionHandler
  helper_method :mobile_app?

private
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
