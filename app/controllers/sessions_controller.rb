class SessionsController < ApplicationController

  def new

  end

  def create # the session params sent to the browser are 'params[:session] == {email: "xxx@xxx.xxx", password: "<bla bla bla>"}', meaning that the value for :session key is another hash.
    user = User.find_by(email: params[:session][:email].downcase) #downcase ensures a match if the address is indeed valid.
    if user #checks if users exists in the db.
      if user.authenticate(params[:session][:password]) # if user exists, checks if the input in the password form field is indeed associated with the user that has the email provided in the email form field.
        remember(user) # helper defined on 'sessions_helper.rb'
        log_in(user) #helper defined on 'sessions_helper.rb'
        redirect_to(user) #compact redirect; Rails automatically gets URL to this specific 'user' profile page through 'user_url(user)' (note that the argument must be an existing user on the DB.)
      else # display alert for 'wrong password' if password doesn't matches the one registered in the account.
        flash.now[:danger] = "Wops! Wrong password!"
        render 'new'
      end
    else # display alert + inputted e-mail if the e-mail doesn't match any account.
    flash.now[:danger] = "Wops! The email #{params[:session][:email]} is not registered."
    render 'new'
    end
  end

  def delete # delete is different than destroy;
    log_out if logged_in?# defined on '/app/helpers/sessions_helper.rb'; logout should only be available for logged_in users.
    redirect_to(root_url) # root_path would add the path to the current URL (/logout).
  end

end
