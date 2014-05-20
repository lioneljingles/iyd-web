module ApplicationHelper
    
  def current_user
    User.includes(:organization).find_by_id(session[:user_id]) unless session[:user_id].nil?
  end
  
end
