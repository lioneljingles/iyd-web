module ApplicationHelper
  
  def current_user
    session[:current_user]
  end
  
  def logged_in?
    !current_user.nil?
  end
  
end
