require 'csv'

namespace :data do
  desc 'Import organization data from form Wufoo CSV form'
  task import_org_csv: :environment do
    orgs = CSV.parse(File.read(Rails.root + 'lib/tasks/docs/wufoo-forms.csv'), :headers => true)
    rows.each do |row|
      # create generic password
      org = Organization.new({
        email: row[34],
        password: 
        name: row[1],
        contact: row[26] + ' ' + row[27],
        phone: row[35],
        summary: 
        description: 
        website: row[36]
      })
      (2..16).each do |i|
        unless row[i].blank?
          tag = Tag.find_by_name(row[i])
          org.tags << tag unless tag.nil?
        end
      end
    end
  end
end