class UserMailer < ActionMailer::Base
  
  default :from => '"It\'s Your District" <info@itsyourdistrict.org>'
 
  def welcome(id)
    @user = User.find_by_id(id)
    unless @user.nil?
      mail(
        :to => @user.email, 
        :subject => 'Welcome to It\'s Your District!',
        :bcc => 'liz@itsyourdistrict.org'
      ).deliver
    end
  end
  
  def reset_instructions(id)
    @user = User.find_by_id(id)
    unless @user.nil?
      mail(:to => @user.email, :subject => "Password for It's Your District").deliver
    end
  end
  
  def contact(email, message, slug)
    @email = email
    @message = message
    @org = Organization.find_by_slug(slug)
    mail(:to => @org.user.email, :subject => 'You have a message through It\'s Your District').deliver
  end
  
end