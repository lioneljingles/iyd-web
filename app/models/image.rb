class Image < ActiveRecord::Base
  
  belongs_to :organization
  
  has_attached_file :image,
    styles: { large: ["920x300>#", :jpg], small: ["440x200>#", :jpg] }, 
    default_url: "/images/:style/missing.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
end