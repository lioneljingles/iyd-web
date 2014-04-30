class RootController < ApplicationController

  def placeholder
  end
  
  def index
    @tags = Tag.all
  end
  
  def contact
    @org = Organization.find_by_slug(params[:slug])
    render partial: 'contact'
  end
  
  def sent
    UserMailer.contact(params[:email], params[:message], params[:slug])
  end
  
  def about
  end
  
  def missing
  end
  
end