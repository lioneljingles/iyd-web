require 'bcrypt'
require 'securerandom'
include Rails.application.routes.url_helpers


class Organization < ActiveRecord::Base
  
    
  has_and_belongs_to_many :tags
  has_many :images, dependent: :destroy
  
  validates :state, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true, confirmation: true
  validates :name, presence: true, uniqueness: true
  validates :summary, presence: true
  validates :district, presence: true
  validates :city, presence: true
  
  serialize :settings, JSON
  
  before_validation :assign_defaults, on: :create
  
  module Role
    REMOVED = -1
    NEW = 0
    ACTIVE = 1
    ADMIN = 2
  end
  
  def self.authenticate(email, password)
    if org = find_by_email(email)
      if BCrypt::Password.new(org.password).is_password? password
        return user
      end
    end
    return nil
  end
  
  def location
    'District ' + self.district + ', ' + self.city
  end
  
  def short_website
    self.website.gsub(/\Ahttps?:\/\//, '')
  end
  
  def phone_number
    
  end
  
  def reset_password
    self.reset_token = SecureRandom.uuid()
    if self.save
      UserMailer.reset_instructions(self.id)
    end
  end
  
  def self.page(row)
    limit = row == 0 ? 4 : 3
    offset = row == 0 ? 0 : 2 * row + 1
    orgs = Organization.all.includes(:images).limit(limit).offset(offset)
    page = []
    orgs.each_with_index do |org, i|
      page << org.js_format(i)
    end
    return page
  end
  
  def js_format(i)
    {
      name: self.name,
      summary: self.summary,
      image: self.images.first.image.url(i == 0 ? :large : :small),
      path: org_slug_path(slug: self.slug),
      contact: contact_path(slug: self.slug)
    }
  end

  private
  
  def assign_defaults
    self.state = Organization::Role::NEW
    self.district = 6
    self.city = 'San Francisco'
    self.state = 'CA'
    self.slug = self.name.parameterize
    if (self.website =~ /\Ahttps?/)
      self.website = 'http' + self.website
    end
    self.password = BCrypt::Password.create(self.password)
  end
  
end


