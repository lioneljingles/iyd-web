class SessionsController < ApplicationController
    
  def new
    render partial: 'new'
  end

  def create
    
  end

  def destroy
    
  end
  
  def register
    render partial: 'register'
  end
  
  def reset
    render partial: 'reset'
  end

end