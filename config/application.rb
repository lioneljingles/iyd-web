require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module IydWeb
  class Application < Rails::Application
    ORG_SHUFFLE  = {
      date: Date.today,
      order: []
    }
    def self.verify_shuffle_orgs()
      if IydWeb::Application::ORG_SHUFFLE[:order].empty? or Date.today > IydWeb::Application::ORG_SHUFFLE[:date]
        org_ids = Organization.where(visibility: Organization::Visibility::PUBLIC).select(:id)
        IydWeb::Application::ORG_SHUFFLE[:order] = org_ids.map{|record|record.id}.shuffle
        IydWeb::Application::ORG_SHUFFLE[:date] = Date.today
      end
    end
  end
end
