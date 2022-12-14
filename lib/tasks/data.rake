namespace :data do
  
  desc 'Add IYD admin account'
  task add_iyd: :environment do
    user = User.create({
      email: 'info@itsyourdistrict.org',
      password: '##########',
      name: "Lionel Jingles",
      role:  User::Role::ADMIN
    })
    org = Organization.new({
      name: "It's Your District",
      summary: "It's Your District is a comprehensive database that provides a platform for people seeking to serve their community. Community conscious neighbors and organizations can network, advocate, and connect with like-minded groups and individuals in San Francisco's District 6.",
      website: 'http://www.itsyourdistrict.org'
    })
    org.visibility = Organization::Visibility::PRIVATE
    org.images << Image.create(image: URI.parse('http://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/San_Francisco_Pride_Parade_2012-6.jpg/1280px-San_Francisco_Pride_Parade_2012-6.jpg'))
    org.tags = Tag.where(name: 'Tech')
    org.user = user
    org.save!
  end
  
  desc 'Remove IYD admin account'
  task remove_iyd: :environment do
    Organization.find_by_email('info@itsyourdistrict.org').destroy
  end
  
  desc 'Fix user names'
  task fix_user_names: :environment do
    list = [
      { email: 'kbaker@tndc.org', contact: 'Kelly Baker' },
      { email: 'volunteer@evictiondefense.org', contact: 'Sandy Enriquez' },
      { email: 'sffdnert@sfgov.org', contact: 'Lt. Erica Arteseros' },
      { email: 'stephanie@nomadgardens.org', contact: 'Stephanie Goodson' },
      { email: 'mhasick@ecs-sf.org', contact: 'Mallory Hasick' },
      { email: 'echan@glide.org', contact: 'Eden Chan' },
      { email: 'adesai@yli.org', contact: 'Avni Desai' },
      { email: 'jason@counterpulse.org', contact: 'Jason McArthur' },
      { email: 'sfoasis@sfoasis.org', contact: 'Megan Hamilton' },
      { email: 'anh@nomnic.org', contact: 'Anh' },
      { email: 'boxoffice@cuttingball.com', contact: 'Suzanne Appel' },
      { email: 'westbayafterschool@gmail.com', contact: 'Estephanie Sunga' },
      { email: 'info@ywamsanfrancisco.org', contact: 'Tim Svoboda' },
      { email: 'adam@centerfornewmusic.com', contact: 'Adam Fong' },
      { email: 'info@unitedplayaz.org', contact: 'Rudy Corpuz' },
      { email: 'mehler@unitehere.org', contact: 'Micah Ehler' },
      { email: 'tenderloinwalkingtours@yahoo.com', contact: 'Del Seymour' },
      { email: 'rjoyce@healthright360.org', contact: 'Rob Joyce' }
    ]
    for item in list do
      user = User.find_by_email(item[:email])
      user.name = item[:contact]
      user.save!
    end
  end
  
  desc 'Remove unusual characters from summaries'
  task remove_chars: :environment do
    Organization.all.each do |org|
      org.summary = org.summary.gsub(/\n|\r/, '')
      org.save!
    end
  end
  
  desc 'Add new tags - Sports, LGBT, Elderly Care'
  task add_new_tags: :environment do
    ['Sports', 'LGBT', 'Elderly Care'].each do |name|
      if Tag.where(name: name).count == 0
        Tag.create!(name: name)
      end
    end
  end
  
  desc 'Add test opportunities'
  task add_test_opps: :environment do
    roles = [
      'Chief Awesome Guy',
      'Mister Amazing',
      'Happy Intern',
      'Super Helpful Buddy',
      'VP of Awesome',
      'Big Boss',
      'Executive',
      'Food Preparing Guru',
      'Senor Espectacular',
      'Chef',
      'Sous-Chef',
      'Happy Go-Go Robot',
      'Duderooni',
      'Hashtag Manager',
      'Salesperson'
    ]
    descriptions = [
      "This is a sweet one-liner.",
      "This one has two lines!\r\nExciting!!!",
      "This has a list of things:\r\nThis is the first thing.\r\nThis is the second thing!\r\nThis is the third thing."
    ]
    orgs = Organization.all.order(:order).limit(15).shuffle
    for i in 0..14
      start_date = nil
      end_date = nil
      rando = rand(3)
      start_date = Date.today + 10 + rand(20) if rando > 0
      end_date = start_date + 2 + rand(10) if rando > 1
      description = descriptions[rand(3)]
      position = rand(3)
      orgs[i].opportunities.create({
        position: position,
        title: roles[i],
        description: description,
        start_date: start_date,
        end_date: end_date
      })
      puts "Created opportunity for #{orgs[i].name}"
    end
  end
  
end

