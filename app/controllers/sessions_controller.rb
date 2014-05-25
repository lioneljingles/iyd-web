class SessionsController < ApplicationController

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
        email: user.email,
        org: user.organization.name, 
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

end