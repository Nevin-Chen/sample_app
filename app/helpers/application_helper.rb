module ApplicationHelper
  
  def full_title(title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    if title.empty?
      base_title
    else
      title + " | " + base_title
    end
  end
  
  def is_logged_in?
    !session[:user_id].nil?
  end
end
