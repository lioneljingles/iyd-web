class UserMailer < ActionMailer::Base
  
  include Resque::Mailer
  default :from => '"It\'s Your District" <info@itsyourdistrict.org>'
 
  def welcome(id)
    @user = User.find_by_id(id)
    mail(
      :to => to_email(@user), 
      :subject => 'Welcome to It\'s Your District!',
      :bcc => ['liz@itsyourdistrict.org', 'ybarthaud@itsyourdistrict.org']
    )
  end
  
  def reset_instructions(id)
    @user = User.find_by_id(id)
    mail(:to => to_email(@user), :subject => 'Password Reset for It\'s Your District Account')
  end
  
  def contact(email, message, slug)
    @email = email
    @message = message
    @org = Organization.find_by_slug(slug)
    mail(:to => to_email(@org.user), :subject => 'Message via It\'s Your District')
  end
  
  private
  
  def to_email(user)
    if user.nil? or Rails.env.development?
      'mrjingles@gmail.com'
    else
      user.email
    end
  end
  
end