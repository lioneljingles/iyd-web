require 'bcrypt'
require 'securerandom'
include Rails.application.routes.url_helpers

class User < ActiveRecord::Base
  
  has_one :organization
  validates :role, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true, confirmation: true
  validates :name, presence: true, uniqueness: true  
  serialize :settings, JSON
  
  before_validation :assign_defaults, on: :create
  
  module Role
    REMOVED = -1
    USER = 0
    ADMIN = 1
  end
  
  def self.authenticate(email, password)
    user = User.find_by_email(email)
    unless user.nil?
      if user.verify_password(password)
        return user
      end
    end
    return nil
  end
  
  def verify_password(password)
    return BCrypt::Password.new(self.password).is_password? password
  end
  
  def update_password(password)
    self.password = BCrypt::Password.create(password)
  end
    
  def reset_password
    self.reset_token = SecureRandom.uuid()
    if self.save
      UserMailer.reset_instructions(self.id)
    end
  end

  private
  
  def assign_defaults
    self.role = User::Role::USER
    self.password = BCrypt::Password.create(self.password)
  end
  
end

