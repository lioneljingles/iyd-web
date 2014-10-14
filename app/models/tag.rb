class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :organizations
  
  def self.org_page(tag, row)
    IydWeb::Application.verify_shuffle_orgs()   
    tag = Tag.find_by_name(tag)
    offset = row == 0 ? 0 : 2 * row + 1
    limit = row == 0 ? 3 : 2
    if tag.nil?
      page = Organization.page(row, nil, nil)
    else
      orgs = tag.organizations.where(visibility: Organization::Visibility::PUBLIC)
        .select(:id, :name, :summary, :slug, :city, :district)
        .includes(:tags, :images).order(:order).offset(offset).limit(limit)
      page = []
      orgs.each_with_index do |org, i|  
        page << org.js_format(i)
      end
    end
    return page
  end
  
end