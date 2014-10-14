include Rails.application.routes.url_helpers

class Organization < ActiveRecord::Base
  
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :images, dependent: :destroy
  
  validates :visibility, presence: true
  validates :state, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :summary, presence: true
  validates :district, presence: true
  validates :city, presence: true
  
  before_validation :assign_defaults, on: :create
  
  module Visibility
    REMOVED = -1
    NEW = 0
    PRIVATE = 1
    PUBLIC = 2
  end
    
  def location
    "#{self.city}, District #{self.district}"
  end
  
  def short_website
    self.website.gsub(/\Ahttps?:\/\//, '')
  end
  
  def contact
    contact_path(slug: self.slug)
  end
  
  def profile(params={})
    params[:slug] = self.slug
    org_slug_path(params)
  end
  
  def phone_number
    
  end
  
  def truncated_summary
    if self.summary.length > 250
      truncated_summary = self.summary[0..250].gsub(/[\W_]*$/, '')
      truncated_summary += '...'
    else
      self.summary
    end
  end
  
  def self.shuffleOrder
    orgs = Organization.all.shuffle
    i = 1
    orgs.each do |org|
      org.order = i
      org.save()
      i += 1
    end
  end
  
  def self.page(row, search, district)
    IydWeb::Application.verify_shuffle_orgs()
    offset = row == 0 ? 0 : 2 * row + 1
    limit = row == 0 ? 3 : 2
    if not search.nil?
      orgs = Organization.where(visibility: Organization::Visibility::PUBLIC)
        .where("LOWER(name) LIKE ?", "%#{search.downcase}%").select(:id, :name, :summary, :slug, :city, :district)
        .includes(:tags, :images).order(:order).offset(offset).limit(limit)
    elsif not district.nil?
      orgs = Organization.where(visibility: Organization::Visibility::PUBLIC)
        .where(district: district).select(:id, :name, :summary, :slug, :city, :district)
        .includes(:tags, :images).order(:order).offset(offset).limit(limit)
    else
      orgs = Organization.where(visibility: Organization::Visibility::PUBLIC)
        .select(:id, :name, :summary, :slug, :city, :district)
        .includes(:tags, :images).order(:order).offset(offset).limit(limit)
    end
    page = []
    orgs.each_with_index do |org, i|
      page << org.js_format(i)
    end
    return page
  end
  
  def js_format(i)
    {
      name: self.name,
      summary: self.truncated_summary,
      image: self.images.last.image.url(i == 0 ? :large : :small),
      path: self.profile,
      contact: self.contact,
      location: self.location,
      tags: self.tags.map{|tag| tag.name}
    }
  end

  private
  
  def assign_defaults
    self.visibility = Organization::Visibility::PUBLIC
    self.city = 'San Francisco'
    self.state = 'CA'
    self.slug = self.name.parameterize
    if not self.website.blank? and (self.website =~ /\Ahttps?:\/\//).nil?
      self.website = 'http://' + self.website
    end
    self.summary.gsub(/\n|\r/, '')
  end
  
end


