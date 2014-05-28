class AdminController < ApplicationController
  
  before_action :require_admin

  def index
    @users = User.all
  end
  
  def impersonate
    user = User.find(params[:id].to_i)
    session[:user_id] = user.id
    redirect_to user.organization.profile
  end
  
  private
  
  def require_admin
    unless current_user and current_user.email == 'info@itsyourdistrict.org'
      render 'root/missing'
    end
  end
  
end