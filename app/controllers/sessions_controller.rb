class SessionsController < ApplicationController
    def create
      auth_hash = request.env['omniauth.auth']
      # Handle the authentication callback and user data as needed
  
      redirect_to root_path
    end
  end
  