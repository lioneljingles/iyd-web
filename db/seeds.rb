# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tags = [
  'Animals',
  'Art',
  'Children',
  'Education', 
  'Environment',
  'Fundraising', 
  'Faith', 
  'Homelessness', 
  'Legal',
  'Nutrition', 
  'Safety',
  'Social Justice',
  'Tech',
  'Transportation',
  'Other'
]

for tag in tags
  Tag.create(name: tag)
end
