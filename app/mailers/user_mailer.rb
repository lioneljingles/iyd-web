class UserMailer < ActionMailer::Base
  
  default :from => '"It\'s Your District" <info@itsyourdistrict.org>'
 
  def welcome(id)
    @user = User.find_by_id(id)
    if @user.nil? or Rails.env.development?
      puts "[DEV] Mailing user: #{@user.email}"
    else
      mail(
        :to => @user.email, 
        :subject => 'Welcome to It\'s Your District!',
        :bcc => ['liz@itsyourdistrict.org', 'ybarthaud@itsyourdistrict.org']
      ).deliver
    end
  end
  
  def reset_instructions(id)
    @user = User.find_by_id(id)
    if @user.nil? or Rails.env.development?
      puts "[DEV] Mailing user: #{@user.email}"
    else
      mail(:to => @user.email, :subject => "Password for It's Your District").deliver
    end
  end
  
  def contact(email, message, slug)
    @email = email
    @message = message
    @org = Organization.find_by_slug(slug)
    if @org.nil? or @org.user.nil? or Rails.env.development?
      puts "[DEV] Mailing user: #{@user.email}"
    else
      mail(:to => @org.user.email, :subject => 'You have a message through It\'s Your District').deliver
    end
  end
  
end