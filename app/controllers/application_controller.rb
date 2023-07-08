class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :user_signed_in?
  
    def requeres_authentication
      redirect_to root_path, alert: 'Requires authentication' unless user_signed_in?
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    end
  
    def user_signed_in?
      !!current_user
    end
  end