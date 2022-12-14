IydWeb::Application.configure do
  
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  
  config.url_base = 'http://localhost:3000'
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'itsyourdistrict.org',
    user_name: 'info@itsyourdistrict.org',
    password: 'gr8BALLSofFIRE',
    authentication: 'plain',
    enable_starttls_auto: true
  }
  
  # config.consider_all_requests_local = false
  
end
