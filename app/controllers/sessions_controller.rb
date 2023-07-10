class SessionsController < ApplicationController
  # before_action :require_guest
  layout false
  def create
    auth_hash = request.env['omniauth.auth']
    uid = auth_hash.uid
    nickname = auth_hash.info['nickname']
    github_access_token = auth_hash.credentials.token
    @user = User.find_or_create_by(nickname: nickname, uid: uid, github_access_token: github_access_token)

    if @user.persisted?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def delete
    session[:user_id] = nil
    redirect_to root_path
  end
end
