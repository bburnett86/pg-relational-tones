require 'rspotify'
class SessionController < ApplicationController

  def login
    @user = User.new
  end

  def import

  end

  def logout
    session.delete(:user_id)
    flash.delete(:errors)
    redirect_to '/'
  end

  def register
    redirect_to '/auth/spotify'
  end

  def connect
    @user = User.new
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  end

  def authenticate
    if user = User.authenticate(login_params[:email], login_params[:password])
      session[:user_id] = user.id
      redirect_to "/playlists"
    else
      flash[:errors] = user.errors.full_messages
      redirect_to '/login'
    end
  end

  private
  def login_params
    params.require(:user).permit(:email, :password)
  end

end
