class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # this 'before_filter' runs a method before the specified methods :edit and :update (ie only the owner of a profile can edit this profile).
  before_action :correct_user, only: [:edit, :update] # this will assure that the 'correct user' is accessing the page (i.e. an admin-only page or other user settings page)
  before_action :admin_user, only: [:destroy] # if the current user is not an admin, the 'destroy' method won't be executed.

  def index
    @users = User.paginate(page: params[:page]) # available from will_paginate on Gemfile
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]) #available from 'will_pagine' on Gemfile
  end

  def create
    @user = User.new(user_params)   #uses the parameters (name: "aaa", email: "aaa",etc) posted in the URL after the 'submit' button on user/new is clicked on.
                                    #also note that '(params)' returns a hash of hashes, while (params[:user]) return the hash which contains the user's attributes.
                                    #the form is not secure just by (params[:user]), as any user can use CSRF attacks and, say, pass "admin=true" with curl and sign itself as an admin.
                                    #better to use the 'strong_params' convention of Rails 4 and permit only a pre-defined set of params to be passed by the user (see user_params below).
    if @user.save #default action for saved user.
      # commented out since the account now needs to be activated. log_in(@user)
      @user.send_activation_email # defined on /models/user.rb
      flash[:notice] = "Thanks for signing up! Please check your e-mail inbox to activate your account." #popup triggered when new account is created.
      # commented out since the account now needs to be activated. session[:user_id] = @user.id #session for the user is not created alongside the own user.
      # commented out since the account now needs to be activated. redirect_to @user #equivalent to 'redirect_to(user_url(@user))', rails infer the 'user_url()' method
      redirect_to root_url
    else
      render 'new' #renders the form page (the view [new], not the route [signup]) again (with errors output) if the user wasn't valid.
    end

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # 'user_params' is used here to make use of the strong_params feature and prevent the mass assignment vulnerability (which could enable an user changing its account status to 'admin' for instance)
      flash[:success] = "Profile information was successfully updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy # 'destroy' and note 'delete' because while 'delete' only erases an user, 'destroy' runs validations before doing so.
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private #private methods which are better off running exclusively on the back end of the app.

  def user_params #prevents CSRF attacks
    params.require(:user).permit(:name, :email, :password, :password_confirmation) #for the 'user' method in the 'params' object, only these attributes can be passed; all the rest are banned.
  end

  # Moved this method to application_controller.rb
  # def logged_in_user
  #   unless logged_in?
  #     store_location # defined on sessions_helper.rb
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   else
  #     current_user
  #   end
  # end

  def correct_user # define a method to check if the page requested by the user corresponds to the page the account should have access to.
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) # defined on helpers/sessions_helper.rb
  end

  def admin_user
    redirect_to(root_url) unless current_user.role == 1 # if the request wasn't sent by an admin, redirect to URL. Impossibilitate attacks to the website via command line (since even though the link is not displayed, the request can be sent unless specifically forbidden)
  end

end
