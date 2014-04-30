class SessionsController < ApplicationController
    
  def new
    render partial: 'new'
  end

  def create
    user = Organization.authenticate(params[:email], params[:password])
    if user.nil?
      render json: {success: false}
    else
      session[:user] = user
      render json: {success: true, name: user.name, url: org_slug_path(user)}
    end
  end

  def destroy
    session[:user] = nil
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