IydWeb::Application.configure do
  
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.assets.version = '1.0'
  # config.log_level = :info
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  
  config.url_base = "http://itsyourdistrict.org"
    
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
  
  IydWeb::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :sender_address => %{"Exemption Notifier" <info@itsyourdistrict.org>},
      :exception_recipients => %w{mrjingles@gmail.com}
    }
  
end
