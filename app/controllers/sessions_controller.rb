# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :track_session, only: :create
  
  private
  
  def track_session
    return unless current_user
    
    current_user.sessions.create(
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      last_activity_at: Time.current
    )
  end
end