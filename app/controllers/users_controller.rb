class UsersController < ApplicationController
  
  def password
    @token = params[:token]
    if @token
      @org = Organization.find_by_reset_token(@token)
      if @org.nil?
        render '_not_found'
      else
        render '_password'
      end
    else
      @org = current_user
      if @org.nil?
        render partial: 'password'
      else
        render partial: 'not_found'
      end
    end
  end

end