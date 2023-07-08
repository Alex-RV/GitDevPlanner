class SessionsController < ApplicationController
    def create
      auth_hash = request.env['omniauth.auth']
      print(auth_hash)
      redirect_to root_path
    end
  end