class SessionsController < ApplicationController
  before_action :redirect_authenticated_user, except: [:delete]
  layout false

  def create
    auth_hash = request.env['omniauth.auth']
    uid = auth_hash.uid
    nickname = auth_hash.info['nickname']
    github_access_token = auth_hash.credentials.token

    @user = User.find_or_create_by(nickname: nickname, uid: uid)
    @user.update(github_access_token: github_access_token) 


    if @user.save
      session[:user_id] = @user.id
      session[:nickname] = nickname
      session[:github_access_token] = github_access_token
      redirect_to root_path
    else
      redirect_to root_path, alert: 'Failed to create or update user'
    end
  end

  def delete
    session[:user_id] = nil
    redirect_to root_path
  end

  def redirect_authenticated_user
    redirect_to root_path if user_signed_in?
  end
end
