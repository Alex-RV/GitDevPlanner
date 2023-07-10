class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    uid = auth_hash.uid
    nickname = auth_hash.info['nickname']
    @user = User.find_or_create_by(nickname: nickname, uid: uid)

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
