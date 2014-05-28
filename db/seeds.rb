require 'securerandom'

tags = [
  'Art',
  'Education', 
  'Environment',
  'Faith', 
  'Health',
  'Homelessness', 
  'Housing',
  'Legal',
  'Music',
  'Nutrition', 
  'Safety',
  'Social Justice',
  'Tech',
  'Violence Prevention',
  'Youth'
]

Tag.all.each do |tag|
  tag.destroy
end

for tag in tags
  Tag.create(name: tag)
end

list = [
   # {
   # email: 'itsyourdistrict@gmail.com',
   # name: 'It\'s Your District',
   # contact: 'Lionel Jingles',
   # phone: '415-902-3240',
   # summary: 'We launched!',
   # website: 'http://www.itsyourdistrict.org',
   # address_1: '123 Real St.',
   # address_2: '',
   # zip: '94107',
   # image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/San_Francisco_Pride_Parade_2012-6.jpg/1280px-San_Francisco_Pride_Parade_2012-6.jpg',
   # tags: ['Community', 'Tech']
   # },
   {
     email: 'kbaker@tndc.org',
     name: 'Tenderloin Neighborhood Development Corporation',
     contact: 'Kelly Baker',
     phone: '4153583975',
     summary: 'TNDC provides affordable housing and services for low-income people in the Tenderloin and throughout San Francisco, to promote equitable access to opportunity and resources.',
     website: 'http://www.tndc.org',
     address_1: '201 Eddy St',
     address_2: '',
     zip: '94102',
     image_url: 'http://www.tndc.org/wp-content/uploads/FeaturedVerticalGarden.jpg',
     tags: ['Housing']
   },
   {
     email: 'volunteer@evictiondefense.org',
     name: 'Eviction Defense Collaborative',
     contact: 'Sandy Enriquez',
     phone: '4159470797x2161',
     summary: 'The Eviction Defense Collaborative is a non-profit legal clinic dedicated to preventing homelessness, preserving affordable housing, and protecting San Francisco\'s diversity. We offer legal assistance to tenants who are facing eviction and no-interest loans to tenants who have fallen behind in rent payments.',
     website: 'http://www.evictiondefense.org',
     address_1: '995 Market St',
     address_2: 'Suite 1200',
     zip: '94103',
     image_url: 'http://www.evictiondefense.org/img/gallery/2007_volunteer_party/gallery_2.jpg',
     tags: ['Social Justice', 'Homelessness', 'Legal']
   },
   {
     email: 'sffdnert@sfgov.org',
     name: 'SFFD NERT',
     contact: 'Lt. Erica Arteseros',
     phone: '4159702022',
     summary: 'NERT (Neighborhood Emergency Response Team) is a free training program for individuals, neighborhood groups and community-based organizations in San Francisco. Through this program, individuals will learn the basics of personal preparedness and prevention.',
     website: 'http://sfgov.org/sfnert',
     address_1: '',
     address_2: '',
     zip: '',
     image_url: 'http://sfbay.ca/home/wp-content/uploads/2012/04/IMG_4400-1000x563.jpg',
     tags: ['Education', 'Safety']
   },
   {
     email: 'stephanie@nomadgardens.org',
     name: 'NOMADgardens',
     contact: 'Stephanie Goodson',
     phone: '4152975739',
     summary: 'NOMADgardens\' mission is to find an empty lot in a developing neighborhood, fill it with portable plots of dirt and then invite the community in to build their gardens. More than just a garden, it is designed to be a hub for the community.',
     website: 'http://www.nomadgardens.org',
     address_1: '1302 Willard Street',
     address_2: '',
     zip: '',
     image_url: 'http://www.nomadgardens.org/wp-content/uploads/2014/04/140406_NOMADgardens_VolunteerDay_Group1.jpg',
     tags: ['Education', 'Environment', 'Nutrition']
   },
   {
     email: 'mhasick@ecs-sf.org',
     name: 'Episcopal Community Services',
     contact: 'Mallory Hasick',
     phone: '4154873300',
     summary: 'Episcopal Community Services of San Francisco helps homeless and very low-income people every day and every night obtain the housing, jobs, shelter and essential services that each person needs to prevent and end homelessness.',
     website: 'http://www.ecs-sf.org',
     address_1: '165 8th Street',
     address_2: '',
     zip: '94103',
     image_url: 'http://www.ecs-sf.org/_images/main_careers_jobs.jpg',
     tags: ['Homelessness']
   },
   {
     email: 'echan@glide.org',
     name: 'The Glide Foundation',
     contact: 'Eden Chan',
     phone: '4156746081',
     summary: 'GLIDE\'s mission is to create a radically inclusive, just and loving community mobilized to alleviate suffering and break the cycles of poverty and marginalization.',
     website: 'http://glide.org',
     address_1: '330 Ellis Street',
     address_2: '',
     zip: '94102',
     image_url: 'https://itsyourdistrict.wufoo.com/cabinet/mabxluo03t6is3/fFqOab09yxk%3D/8.jpg',
     tags: ['Social Justice', 'Homelessness', 'Nutrition', 'Youth']
   },
   {
     email: 'adesai@yli.org',
     name: 'Youth Leadership Institute',
     contact: 'Avni Desai',
     phone: '4158369160',
     summary: 'We are a growing organization that is committed to social justice and racial equity. We work with youth and adult partners to make positive changes in our community by looking at policy, norms, youth opportunities, and more.',
     website: 'http://ylisanfrancisco.wordpress.com',
     address_1: '28 Second Street',
     address_2: '#400',
     zip: '94105',
     image_url: 'http://ylisanfrancisco.files.wordpress.com/2012/11/community-retreat-picture3.png',
     tags: ['Social Justice', 'Nutrition', 'Youth']
   },
   {
     email: 'jason@counterpulse.org',
     name: 'CounterPULSE',
     contact: 'Jason McArthur',
     phone: '4156262060',
     summary: 'Community development through the creation of risk-taking art that shatters assumptions.',
     website: 'http://www.counterpulse.org',
     address_1: '1310 Mission Street',
     address_2: '',
     zip: '94103',
     image_url: 'http://counterpulse.org/wp-content/uploads/Facade-Image_closeup.jpg',
     tags: ['Education', 'Social Justice', 'Art']
   },
   {
     email: 'sfoasis@sfoasis.org',
     name: 'Oasis For Girls',
     contact: 'Megan Hamilton',
     phone: '4157017991',
     summary: 'Oasis For Girls partners with young women from under-resourced communities to help them cultivate the skills, knowledge, and confidence to discover their dreams and build strong futures. Oasis\' three program series, in Life Skills, Arts, and Career Exploration, provides girls with opportunities to focus on internal awareness and external skills to develop into strong and creative leaders.',
     website: 'http://www.sfoasis.org',
     address_1: '1091 Mission Street',
     address_2: '',
     zip: '94103',
     image_url: 'http://www.sfoasis.org/wp-content/uploads/2013/05/Oasis_wintergroup.jpg',
     tags: ['Education', 'Social Justice', 'Tech', 'Art']
   },
   {
     email: 'anh@nomnic.org',
     name: 'Nomnic',
     contact: 'Anh',
     phone: '4158940649',
     summary: 'Nomnic provides assistance to small businesses and helps organize business owners.',
     website: 'http://www.nomnic.org',
     address_1: '',
     address_2: '',
     zip: '',
     image_url: 'http://media.bizj.us/view/img/56911/vilkingreg-re*900.jpg',
     tags: ['Tech']
   },
   {
     email: 'boxoffice@cuttingball.com',
     name: 'The Cutting Ball Theater',
     contact: 'Suzanne Appel',
     phone: '4152924700',
     summary: 'The Cutting Ball Theater was founded with a mission to develop productions of experimental new plays and re-visioned classics, with an emphasis on language and images.',
     website: 'http://www.cuttingball.com',
     address_1: '277 Taylor Street',
     address_2: '',
     zip: '94102',
     image_url: 'http://cuttingball.com/wp-content/gallery/ubu-roi-press/review1.jpg',
     tags: ['Art']
   },
   {
     email: 'westbayafterschool@gmail.com',
     name: 'West Bay Pilipino Multi-Service Center',
     contact: 'Estephanie Sunga',
     phone: '4154316266',
     summary: 'West Bay\'s mission is to provide social, health, education, and economic services to children, youth, and their families in the South of Market District of San Francisco and the greater Bay Area with emphasis on the newly arrived immigrant population through a comprehensive social service delivery system, as well as to advocate for the continuation of needed services in the community.',
     website: 'http://westbaycenter.org/',
     address_1: '175 7th St',
     address_2: '',
     zip: '94103',
     image_url: 'https://itsyourdistrict.wufoo.com/cabinet/mabxluo03t6is3/KtNe2pHWViQ%3D/image.jpeg.jpg',
     tags: ['Education', 'Social Justice', 'Youth']
   },
   {
     email: 'info@ywamsanfrancisco.org',
     name: 'YWAM',
     contact: 'Tim Svoboda',
     phone: '4158856543',
     summary: 'Youth With a Mission San Francisco is a non-profit organization that seeks to engage the city of San Francisco with a loving God by reaching out to each sphere of society in unique, relevant, and creative ways.',
     website: 'http://www.ywamsanfrancisco.org',
     address_1: '357 Ellis street',
     address_2: '',
     zip: '94102',
     image_url: 'http://3.bp.blogspot.com/-KxrTQRQJ7eE/Tqc2yrHSLmI/AAAAAAAAAbg/T7eSMDCxrnc/s640/ywam1+copy.jpg',
     tags: ['Social Justice', 'Faith', 'Homelessness', 'Safety']
   },
   {
     email: 'adam@centerfornewmusic.com',
     name: 'Center for New Music',
     contact: 'Adam Fong',
     phone: '4152752466',
     summary: 'The Center for New Music San Francisco, Inc. is a community center for participants of new music in San Francisco. The Center serves the practitioners of creative, non-commercial music by providing the resources they need, including space to work, rehearse, and perform, access to a like-minded community, and access to media resources.',
     website: 'http://centerfornewmusic.com',
     address_1: '55 Taylor Street',
     address_2: '',
     zip: '94102',
     image_url: 'https://itsyourdistrict.wufoo.com/cabinet/mabxluo03t6is3/vGBsl5WVPik%3D/05_919625_456332957778321_1481607057_o.jpg',
     tags: ['Art', 'Music']
   },
   {
     email: 'info@unitedplayaz.org',
     name: 'United Playaz',
     contact: 'Rudy Corpuz',
     phone: '8889752929',
     summary: 'United Playaz is a violence prevention and youth leadership organization that works with San Francisco\'s hardest to reach youth through street outreach, case management, in-school services, recreational activities, and support to incarcerated youth.',
     website: 'http://www.unitedplayaz.org',
     address_1: '1038 Howard Street',
     address_2: '',
     zip: '94103',
     image_url: 'https://itsyourdistrict.wufoo.com/cabinet/mabxluo03t6is3/he8R3KaXpok%3D/img_5959.jpg',
     tags: ['Youth', 'Violence Prevention']
   },
   {
     email: 'mehler@unitehere.org',
     name: 'UNITE HERE! Local 2',
     contact: 'Micah Ehler',
     phone: '4158648770',
     summary: 'UNITE HERE! Local 2 represents about 12,000 workers in the hospitality industries of San Francisco and San Mateo. Local 2 members work at many job sites – including hotels, restaurants, food services, laundries and San Francisco International Airport.',
     website: 'http://www.unitehere2.org/',
     address_1: '209 Golden Gate Avenue',
     address_2: 'Boycott Team',
     zip: '94102',
     image_url: 'http://www.unitehere2.org/wp-content/uploads/dnb9-09sfhotelmarch111.jpg',
     tags: ['Social Justice']
   },
   {
     email: 'tenderloinwalkingtours@yahoo.com',
     name: 'Tenderloin Walking Tours',
     contact: 'Del Seymour',
     phone: '4155741641',
     summary: 'Tenderloin Walking Tours provides cultural, historic and artistic romps through the Theater District.',
     website: 'http://tlwalkingtours.com',
     address_1: '1060 Howard St',
     address_2: '',
     zip: '92108',
     image_url: 'https://farm8.staticflickr.com/7060/6803434384_aa9f6c076b_b.jpg',
     tags: ['Homelessness', 'Art']
   },
   {
     email: 'rjoyce@healthright360.org',
     name: 'HealthRIGHT 360',
     contact: 'Rob Joyce',
     phone: '4157623700',
     summary: 'HealthRIGHT 360 gives hope, builds health, and changes lives for people in need. We do this by providing compassionate, integrated care that includes primary medical, mental health, and substance use disorder treatment.',
     website: 'http://www.healthright360.org',
     address_1: '1735 Mission St',
     address_2: 'Suite 2050',
     zip: '94103',
     image_url: 'https://farm6.staticflickr.com/5331/9179696469_df692796d3_b.jpg',
     tags: ['Health']
   }
]

for fields in list
  user = User.create({
    email: fields[:email],
    name: fields[:contact],
    password: SecureRandom.base64(12)
  })
  org = Organization.new({
    name: fields[:name],
    phone: fields[:phone],
    summary: fields[:summary],
    website: fields[:website],
    address_1: fields[:address_1],
    address_2: fields[:address_2],
    zip: fields[:zip]
  })
  org.images << Image.create(image: URI.parse(fields[:image_url]))
  org.tags = Tag.where(name: fields[:tags])
  org.user = user
  org.save!
end
 
 
