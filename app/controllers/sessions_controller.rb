class SessionsController < ApplicationController
  before_action :redirect_authenticated_user, except: [:delete]
  layout false

  def create
    auth_hash = request.env['omniauth.auth']
    uid = auth_hash.uid
    nickname = auth_hash.info['nickname']
    github_access_token = auth_hash.credentials.token
    email = auth_hash.info['email']
    avatar_url = auth_hash.extra.raw_info.avatar_url

    @user = User.find_or_create_by(nickname: nickname, uid: uid)
    @user.update(github_access_token: github_access_token, email: email, avatar_url: avatar_url)

    if @user.save
      session[:user_id] = @user.id
      session[:nickname] = nickname
      session[:github_access_token] = github_access_token
      session[:email] = email
      session[:avatar_url] = avatar_url
      redirect_to root_path
    else
      redirect_to root_path, alert: 'Failed to create or update user'
    end
  end

  def delete
    session[:user_id] = nil
    session[:nickname] = nil
    session[:github_access_token] = nil
    session[:email] = nil
    session[:avatar_url] = nil
    redirect_to root_path
  end

  def redirect_authenticated_user
    redirect_to root_path if user_signed_in?
  end
end
