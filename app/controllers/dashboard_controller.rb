# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def index
    @user = current_user
    @recent_activity = current_user.sessions.last(5)
  end
end