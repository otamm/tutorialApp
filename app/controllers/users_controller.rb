class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update] # this 'before_filter' runs a method before the specified methods :edit and :update (ie only the owner of a profile can edit this profile).

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)   #uses the parameters (name: "aaa", email: "aaa",etc) posted in the URL after the 'submit' button on user/new is clicked on.
                                    #also note that '(params)' returns a hash of hashes, while (params[:user]) return the hash which contains the user's attributes.
                                    #the form is not secure just by (params[:user]), as any user can use CSRF attacks and, say, pass "admin=true" with curl and sign itself as an admin.
                                    #better to use the 'strong_params' convention of Rails 4 and permit only a pre-defined set of params to be passed by the user (see user_params below).
    if @user.save #default action for saved user.
      log_in(@user)
      flash[:notice] = "Thanks for signing up!" #popup triggered when new account is created.
      session[:user_id] = @user.id #session for the user is not created alongside the own user.
      redirect_to @user #equivalent to 'redirect_to(user_url(@user))', rails infer the 'user_url()' method
    else
      render 'new' #renders the form page (the view [new], not the route [signup]) again (with errors output) if the user wasn't valid.
    end

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

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  private #private methods which are better off running exclusively on the back end of the app.

  def user_params #prevents CSRF attacks
    params.require(:user).permit(:name, :email, :password, :password_confirmation) #for the 'user' method in the 'params' object, only these attributes can be passed; all the rest are banned.
  end

end
