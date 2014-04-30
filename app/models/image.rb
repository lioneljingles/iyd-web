class Image < ActiveRecord::Base
  
  belongs_to :organization
  
  has_attached_file :image,
    :styles => { :large => ["300x300>", :jpg], :small => ["100x100>", :jpg] }, 
    :default_url => "/images/:style/missing.jpg"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
end