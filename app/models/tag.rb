class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :organizations
  
  def self.org_page(row)
    
    limit = row == 0 ? 4 : 3
    offset = row == 0 ? 0 : 2 * row - 1
    
    orgs = Tag.find_by_name(tag).organizations.limit(limit).offset(offset)
    orgs.each_with_index do |org, i|  
      page << {
        name: org.name,
        summary: org.summary,
        image: org.images.first.image.url(i == 0 ? :large : :small),
        path: org_slug_path(slug: org.slug),
        contact: contact_path(slug: org.slug)
      }
    end
  end
end