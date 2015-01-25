module SessionsHelper

  def log_in(user) #this method below (session[]) is default in Rails,it has nothing to do with the Sessions controller.
    session[:user_id] = user.id # generates a session cookie that is destroyed as soon as the session closes (user closes the browser/logs out).
  end                           # [:user_id] attribute is assigned to the id of the user passed as a parameter to log_int method, id is automatically encrypted and retrieved using the encrypt/unencrypt algorithm provided by session[user_id].

  def remember(user) # generates a continuous session for an user (aka 'cookie')
    user.remember # this 'remember' is defined on '/app/models/user.rb'
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_digest # defined on user model. this one is encrypted when saved on the db, thus adding security to cookie assignment.
  end

  def current_user # returns the current logged in user if the page is being accessed by a registered user.
    #@current_user ||= User.find_by(id: session[:user_id]) #note that the instance variable @current_user is conditionally assigned. More info on that and on the data assigned below.
    # if @current_user was assigned to 'User.find(sessions[:user_id])',the '.find()' would raise an exception if the id didn't exist. No problem if the user is actually logged on, but the app would crash if a non-registered user were to access the same page.
    # defining a helper method on this case is helpful because we can promptly use something like 'if current_user.nil?' to display specific content for non-logged in users (and vice-versa) based on what the current_user method returns.
    # Now, the conditional assignment (||=) operator: it would be equivalent to use @current_user = @current_user || User.find_by(id: session[:user_id]), which means: 'if there is already a value assigned to @current_user, do nothing. Else, assign this value x.'
    # works on the same logic as for example the 'a += b' operator, which adds to the variable 'a' its own value + the value of b. The conditional assignment on this specific case is useful because it promptly checks wheter or not there is a session running for 'current_user'
    # before iterating over the database to assign a session that user which has the same id as the one stored on 'sessions[:user_id]'.
    # also recall that the value of 'session[:user_id]' is encrypted and if it already has a value assigned the data returned is the decrypted user.id
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id) # first of all, check if there is a running temporary session. if there's not, check if there is a cookie being sent by the browser, then check if it is a legitimate cookie by a legitimate user.
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user # if user exists
        if user.authenticated?(:remember, cookies[:remember_token]) # defined on /models/user.rb;means 'if this user has a cookie associated with it'
          log_in(user) # logs in the user which has a valid permanent session then assigns 'current_user' that will handle the temporary session
          @current_user = user
        end
      end
    end

  end

  def logged_in? # a shortcut to return either 'true' or 'false' based on wheter or not there is a running session for that user.
    !current_user.nil? #the '!' means 'not', that is, 'the result of current_user.nil? is *not* true'
  end

  def forget(user)
    user.forget # this forget here is defined on the user model.
    cookies.delete(:user_id) # deletes the encrypted user_id from the cookie associated with this session.
    cookies.delete(:remember_token) # deletes the encrypted remember_token from the cookie associated with this session.
  end

  def log_out # deletes the current session.
    session.delete(:user_id) # invokes the 'delete' method that comes with the 'session' object.
    @current_user = nil # clearing the '@current_user' current value is done separatedly from the above action.
  end

  def current_user?(user) # created out of convention, 'current_user' can be used to do exactly this.
    user == current_user
  end

  def store_location # stores the page trying to be accessed unless the page is one which the user would not have access to.
    session[:forwarding_url] = request.url if request.get? # if the request sent is a GET, store the page in session[:forwarding_url]
  end

  def redirect_back_or(default=root_url) # redirects the user to page trying to be accessed or if session[:forwarding_url] is empty, redirects to a default page.
    redirect_to(session[:forwarding_url] || default) # if it is possible to redirect to the page stored in the session[:forwarding_url] variable, redirect there.
    session[:forwarding_url].delete if session[:forwarding_url]
  end

end
