class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new

  end

  def show
    @user.find(params[:id])
  end
end
