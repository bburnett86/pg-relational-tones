require 'rubygems'
require 'json'
class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def import
    current_user.seed_playlists
    current_user.seed_data
    current_user.seed3
    redirect_to '/playlists'
  end

  def new
    redirect_to '/auth/spotify'
  end

  def show
    if !logged_in?
      redirect_to '/'
    end
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash.delete(:errors)
      session[:user_id] = @user.id
      @user.seed3
      @user.seed_playlists
      @user.seed_data
      redirect_to "/import"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to '/auth/spotify/callback'
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    if @user.update(user_params)
      redirect_to "/users/#{@user.id}"
    end
  end

  def destroy
    @user.destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :obj_hash, :password, :password_confirmation)
  end
end
