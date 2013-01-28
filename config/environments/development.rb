BigTuna::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  config.action_controller.page_cache_directory = ::Rails.root.to_s + "/public/cache"

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => '10.10.10.10:3000' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.assets.paths << Rails.root.join("builds")
  
  config.colorize_logging = false

  if File.exists?(File.join(Rails.root, 'config', 'email.yml'))
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = YAML.load_file("config/email.yml")[Rails.env]
  end

end

Grizzled::Rails::Logger.configure do |cfg|
  cfg.flatten = true
  cfg.flatten_patterns = [
    /.*/
  ]
  cfg.dont_flatten_patterns = [
  ]
  cfg.colorize = false
  cfg.timeformat = '%Y/%m/%d %H:%M:%S'
  cfg.format = '[%T] (%S) %M'
end

