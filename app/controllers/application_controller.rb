# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :public_page?
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :terms_of_service])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar])
  end
  
  def public_page?
    devise_controller? || 
    root_path? ||
    public_routes.include?(params[:action])
  end
  
  def public_routes
    ['about', 'contact', 'privacy', 'terms', 'products', 'solutions', 'resources', 'help']
  end
  
  def root_path?
    controller_name == 'home' && action_name == 'index'
  end
end