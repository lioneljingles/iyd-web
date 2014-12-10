include Rails.application.routes.url_helpers

class Opportunity < ActiveRecord::Base
  
  belongs_to :organization
  
  module Visibility
    REMOVED = -2
    EXPIRED = -1
    PUBLIC = 0
  end
  
  module Position
    VOLUNTEER = 0
    INTERN = 1
    EMPLOYEE = 2
  end
  
  def duration
    if self.start_date.blank?
      return 'Ongoing'
    elsif self.end_date.blank?
      return (self.start_date.to_s :human)
    else
      return (self.start_date.to_s :human) + ' — ' + (self.end_date.to_s :human)
    end
  end
  
  def position_type
    if self.position == Opportunity::Position::VOLUNTEER
      return 'Volunteer'
    elsif self.position == Opportunity::Position::INTERN
      return 'Intern'
    elsif self.position == Opportunity::Position::EMPLOYEE
      return 'Employee'
    end
  end
  
  def self.page(row, district, position, duration)
    conditions = {
      visibility: Opportunity::Visibility::PUBLIC,
    }
    not_conditions = {}
    conditions[:position] = position unless position.nil?
    conditions[:organizations] = {district: district.to_s} unless district.nil?
    if duration == 0
      conditions[:start_date] = nil
      conditions[:end_date] = nil
    elsif duration == 1
      not_conditions[:start_date] = nil
      conditions[:end_date] = nil
    elsif duration == 2
      not_conditions[:start_date] = nil
      not_conditions[:end_date] = nil
    end
    opps = Opportunity.includes(organization: :images).joins(:organization)
      .select(:id, :title, :description, :position, :start_date, :end_date, :organization_id)
      .where(conditions).where.not(not_conditions)
      .where('start_date IS NULL OR (end_date IS NULL AND start_date >= :date) OR (end_date >= :date)',
        {date: Date.today()})
      .order(start_date: :asc).offset(row * 5).limit(6)
    page = []
    opps.each do |opp|
      page << opp.js_format
    end
    return page
  end
  
  def js_format
    {
      title: self.title,
      description: self.description,
      position: self.position_type,
      duration: self.duration,
      path: opp_update_path(self.organization.slug, self.id),
      image: self.organization.images.last.image.url(:small),
      org_name: self.organization.name,
      org_location: self.organization.location,
      org_path: self.organization.profile,
      contact_path: self.organization.contact("I am inquiring about the opportunity: #{self.title}.")
    }
  end
  
  def is_expired
    today = Date.today()
    (not start_date.nil? and self.end_date.nil? and start_date < today) or (not end_date.nil? and end_date < today)
  end
  
end




