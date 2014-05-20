class SessionsController < ApplicationController

  include Rails.application.routes.url_helpers

  def new
    render partial: 'new'
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      render json: {success: false}
    else
      session[:user_id] = user.id
      render json: {
        success: true, 
        name: user.organization.name, 
        url: user.organization.profile
      }
    end
  end

  def destroy
    session[:user_id] = nil
    render json: {success: true}
  end
  
  def register
    render partial: 'register'
  end
  
  def reset
    user = Organization.find_by_email(params[:email])
    user.reset_password unless user.nil?
    render partial: 'reset'
  end

end