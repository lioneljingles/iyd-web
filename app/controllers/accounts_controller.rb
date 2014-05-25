class AccountsController < ApplicationController
  
  def edit
    @user = current_user
    render partial: 'edit'
  end
  
  def update
    @user = current_user
    @user.attributes = params.require(:user).permit(:name, :email)
    if @user.save()
      redirect_to Rails.application.routes.url_helpers.root_path
    else
      @errors = {}
      for field, message in @user.errors
        @errors['user_' + field.to_s] = message
      end
      render '_edit'
    end
  end
  
  def edit_password
    @user = current_user
    render partial: 'edit_password'
  end
  
  def update_password
    @user = current_user
    @errors = {}
    if @user.verify_password(params[:user][:current])
      @user.update_password(params[:user][:password])
    else
      @errors['user_current'] = 'incorrect password'
    end
    if @errors.empty? and @user.save()
      redirect_to Rails.application.routes.url_helpers.root_path
    else
      for field, message in @user.errors
        @errors['user_' + field.to_s] = message
      end
      render '_edit_password'
    end
  end
  
  def reset_password
    session[:user_id] = nil if current_user
    user = User.find_by_email(params[:email])
    user.reset_password unless user.nil?
    render partial: 'reset'
  end

end