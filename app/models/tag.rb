class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :organizations
  
  def self.org_page(tag, row)
    IydWeb::Application.verify_shuffle_orgs()   
    tag = Tag.find_by_name(tag)
    offset = row == 0 ? 0 : 2 * row + 1
    limit = row == 0 ? 3 : 2
    valid_ids = tag.organizations.select(:id).map{|record|record.id}
    org_ids = []  
    IydWeb::Application::ORG_SHUFFLE[:order].each do |id|
      org_ids << id if valid_ids.include?(id)
    end
    org_ids = org_ids.slice(offset, limit)
    if tag.nil?
      page = Organization.page(row)
    else
      orgs = tag.organizations.where(id: org_ids)
      page = []
      orgs.each_with_index do |org, i|  
        page << org.js_format(i)
      end
    end
    return page
  end
  
end