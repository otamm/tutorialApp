class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest # creates an unique token that expires after some time to reset that account's password.
      @user.send_password_reset_email # both are defined on models/user.rb
      flash[:info] = "E-mail sent with password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "E-mail address not found."
      render 'new' # will reload the same screen displayed before the POST request was sent.
    end
  end

  def edit

  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in(@user)
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # before filters

  def get_user # searches for an user on the DB and assigns the value to the @user instance variable used through this action.
    @user = User.find_by(email: params[:email])
  end

  def password_blank? #returns true if password is blank.
    params[:user][:password].blank?
  end

  def valid_user # checks the @user defined by the method above and unless it exists and is authenticated, redirects to the home page.
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]) ) # defined on models/user.rb
      redirect_to root_url
    end
  end

  def check_expiration # checks wheter the reset token is valid or not.
    if @user.password_reset_expired? # defined on the user model
      flash[:danger] = "This link has expired, please send a new one to your e-mail."
      redirect_to new_password_reset_url
    end
  end

end
