class RootController < ApplicationController

  def placeholder
  end
  
  def index
    @tags = Tag.all
    @districts = []
    (1..11).each do |n|
      @districts << "#{n.to_s}"
    end
  end
  
  def contact
    slug = params.has_key?(:slug) ? 'it-s-your-district' : params[:slug]
    @org = Organization.find_by_slug(params[:slug])
    render partial: 'contact'
  end
  
  def sent
    UserMailer.contact(params[:email], params[:message], params[:slug]).deliver
    render partial: 'sent'
  end
  
  def about
  end
  
  def missing
  end
  
  def error
  end
  
end