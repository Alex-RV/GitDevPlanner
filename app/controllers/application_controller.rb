class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :user_signed_in?
  
    def requires_authentication
      redirect_to root_path, alert: 'Requires authentication' unless user_signed_in?
    end
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
    end
  
    def user_signed_in?
      current_user.present?
    end
  
    def authenticate_user!
      redirect_to login_path unless user_signed_in?
    end
  end
  