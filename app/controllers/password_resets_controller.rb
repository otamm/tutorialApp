class PasswordResetsController < ApplicationController
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
end
