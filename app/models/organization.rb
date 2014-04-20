class Organization < ActiveRecord::Base
  
  attr_accessible :email, :password, :password_confirmation, :name, :contact_name, :phone, :summary, :description,
    :website, :district, :city, :images, :settings
  
  has_and_belongs_to_many :tags
  
  validates :slug, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true, confirmation: true
  validates :name, presence: true, uniqueness: true
  validates :summary, presence: true
  validates :district, presence: true
  validates :city, presence: true
  
  serialize :images, JSON
  serialize :settings, JSON
  
end