class ApplicationController < ActionController::Base
  
  include ApplicationHelper
  protect_from_forgery with: :exception
  # before_filter: :check_login
  # 
  # def check_login
  #   if session[:user]:
  #   end
  # end
  
end