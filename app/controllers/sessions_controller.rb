class SessionsController < ApplicationController
    def create
      auth_hash = request.env['omniauth.auth']
      uid = auth_hash.uid
      email = auth_hash.info['email']
      print(auth_hash)
      redirect_to root_path
    #   @user = User.find_or_create_by(email:, uid:)
  
    #   if @user.persisted?
    #     # session[:user_id] = @user.id
    #     redirect_to dashboard_path
    #   else
    #     redirect_to root_path
    #   end
    end
  
    def delete
    #   session[:user_id] = nil
      redirect_to root_path
    end
  end