class AccountsController < ApplicationController
  
  def edit
    @user = current_user
    render partial: 'edit'
  end
  
  def update
    @user = current_user
    @user.attributes = params.require(:user).permit(:name, :email)
    if @user.save()
      redirect_to @user.organization.profile({updated_user: true}), status: 303
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
      redirect_to @user.organization.profile({updated_password: true}), status: 303
    else
      for field, message in @user.errors
        @errors['user_' + field.to_s] = message
      end
      render '_edit_password'
    end
  end
  
  def send_reset
    session[:user_id] = nil if current_user
    user = User.find_by_email(params[:email])
    user.send_reset unless user.nil?
    render partial: 'send_reset'
  end
  
  def process_reset
  end
  
  def complete_reset
    token = params[:token]
    @user = User.find_by_reset_token(params[:token])    
    if token.blank? or @user.nil?
      render 'invalid_token'
    else
      @user.update_password(params[:user][:password])
      if @user.save
        session[:user_id] = @user.id
        redirect_to @user.organization.profile({completed_reset: true}), status: 303
      else
        @errors = {}
        for field, message in @user.errors
          @errors['user_' + field.to_s] = message
        end
        render 'process_reset'
      end
    end
  end

end





