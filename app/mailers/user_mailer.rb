class UserMailer < ActionMailer::Base
  
  default :from => 'info@itsyourdistrict.org'
 
  def welcome(id)
    @user = Organization.find_by_id(id)
    unless @user.nil?
      mail(:to => @user.email, :subject => "Welcome to It's Your District!")
    end
  end
  
  def reset(id)
    @user = Organization.find_by_id(id)
    unless @user.nil?
      mail(:to => @user.email, :subject => "Password for It's Your District")
    end
  end
  
  def contact(email, message, slug)
    @email = email
    @message = message
    @org = Organization.find_by_slug(slug)
    mail(:to => @org.email, :subject => 'Welcome to My Awesome Site')
  end
  
end