module SessionsHelper

  def log_in(user) #this method below (session[]) is default in Rails,it has nothing to do with the Sessions controller.
    session[:user_id] = user.id # generates a session cookie that is destroyed as soon as the session closes (user closes the browser/logs out).
  end                           # [:user_id] attribute is assigned to the id of the user passed as a parameter to log_int method, id is automatically encrypted and retrieved using the encrypt/unencrypt algorithm provided by session[user_id].

  def current_user # returns the current logged in user if the page is being accessed by a registered user.
    @current_user ||= User.find_by(id: session[:user_id]) #note that the instance variable @current_user is conditionally assigned. More info on that and on the data assigned below.
    # if @current_user was assigned to 'User.find(sessions[:user_id])',the '.find()' would raise an exception if the id didn't exist. No problem if the user is actually logged on, but the app would crash if a non-registered user were to access the same page.
    # defining a helper method on this case is helpful because we can promptly use something like 'if current_user.nil?' to display specific content for non-logged in users (and vice-versa) based on what the current_user method returns.
    # Now, the conditional assignment (||=) operator: it would be equivalent to use @current_user = @current_user || User.find_by(id: session[:user_id]), which means: 'if there is already a value assigned to @current_user, do nothing. Else, assign this value x.'
    # works on the same logic as for example the 'a += b' operator, which adds to the variable 'a' its own value + the value of b. The conditional assignment on this specific case is useful because it promptly checks wheter or not there is a session running for 'current_user'
    # before iterating over the database to assign a session that user which has the same id as the one stored on 'sessions[:user_id]'.
    # also recall that the value of 'session[:user_id]' is encrypted and if it already has a value assigned the data returned is the decrypted user.id
  end

  def logged_in? # a shortcut to return either 'true' or 'false' based on wheter or not there is a running session for that user.
    !current_user.nil? #the '!' means 'not', that is, 'the result of current_user.nil? is *not* true'
  end

end
