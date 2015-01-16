class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user.find(params[:id])
  end

  def create
    @user = User.new(user_params)   #uses the parameters (name: "aaa", email: "aaa",etc) posted in the URL after the 'submit' button on user/new is clicked on.
                                    #also note that '(params)' returns a hash of hashes, while (params[:user]) return the hash which contains the user's attributes.
                                    #the form is not secure just by (params[:user]), as any user can use CSRF attacks and, say, pass "admin=true" with curl and sign itself as an admin.
                                    #better to use the 'strong_params' convention of Rails 4 and permit only a pre-defined set of params to be passed by the user (see user_params below).
    if @user.save #default action for saved user.
      redirect_to "/users/#{@user.id}"
    else
      render 'new' #renders the form page again (with errors output) if the user wasn't valid.
    end

  end

  private #private methods which are better off running exclusively on the back end of the app.

  def user_params #prevents CSRF attacks
    params.require(:user).permit(:name, :email, :password, :password_confirmation) #for the 'user' method in the 'params' object, only these attributes can be passed; all the rest are banned.
  end

end
