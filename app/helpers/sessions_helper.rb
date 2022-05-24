module SessionsHelper
  
  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #returns the current logged-in user (if any)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  #returns true if user is logged in
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session[:user_id] = nil
    @current_user = nil
  end
end
