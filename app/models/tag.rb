class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :organizations
  
  def self.org_page(tag, row)
    limit = row == 0 ? 4 : 3
    offset = row == 0 ? 0 : 2 * row + 1
    tag = Tag.find_by_name(tag)
    if tag.nil?
      page = Organization.page(row)
    else
      orgs = tag.organizations.limit(limit).offset(offset)
      page = []
      orgs.each_with_index do |org, i|  
        page << org.js_format(i)
      end
    end
    return page
  end
  
end