namespace :data do
  
  desc 'Add IYD admin account'
  task add_iyd: :environment do
    user = User.create({
      email: 'info@itsyourdistrict.org',
      password: 'roygbiv',
      name: "Lionel Jingles",
      role:  User::Role::ADMIN
    })
    organization = Organization.new({
      name: "It's Your District",
      summary: "It's Your District is a comprehensive database that provides a platform for people seeking to serve their community. Community conscious neighbors and organizations can network, advocate, and connect with like-minded groups and individuals in San Francisco's District 6.",
      website: 'http://www.itsyourdistrict.org'
    })
    organization.visibility = Organization.Visibility::PRIVATE
    organization.images << Image.create(image: URI.parse('http://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/San_Francisco_Pride_Parade_2012-6.jpg/1280px-San_Francisco_Pride_Parade_2012-6.jpg'))
    organization.tags = Tag.where(name: 'Tech')
    organization.user = user
    organization.save!
  end
  
  desc 'Remove IYD admin account'
  task remove_iyd: :environment do
    Organization.find_by_email('info@itsyourdistrict.org').destroy
  end
  
end