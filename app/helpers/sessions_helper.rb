module SessionsHelper

  def log_in(user) #this method below (session[]) is default in Rails,it has nothing to do with the Sessions controller.
    session[:user_id] = user.id # generates a session cookie that is destroyed as soon as the session closes (user closes the browser/logs out).
  end                           # [:user_id] attribute is assigned to the id of the user passed as a parameter to log_int method, id is automatically encrypted and retrieved using the encrypt/unencrypt algorithm provided by sessions[user_id].

end
