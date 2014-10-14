require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module IydWeb
  class Application < Rails::Application
    config.shuffle_date = nil
    def self.verify_shuffle_orgs()
      if IydWeb::Application::config.shuffle_date.nil? or Date.today > IydWeb::Application::config.shuffle_date
        Organization.shuffleOrder()
        IydWeb::Application::config.shuffle_date = Date.today
      end
    end
  end
end
