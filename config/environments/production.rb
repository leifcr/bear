Bear::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_controller.page_cache_directory = ::Rails.root.to_s + "/public/cache/"

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  # config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  config.action_mailer.delivery_method = :smtp
  if File.exists?(File.join(Rails.root, 'config', 'email.yml'))
    config.action_mailer.smtp_settings = YAML.load_file("config/email.yml")[Rails.env]
  else
    warn "WARNING: config/email.yml does not exist. Email notifications will not work."
  end

  if Bear.config[:url_host]
    config.action_mailer.default_url_options = { :host => Bear.config[:url_host] }
  else
    warn "WARNING: No url_host set in config/bear.yml. Notification links will not work."
  end

  config.assets.initialize_on_precompile = false

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end

Grizzled::Rails::Logger.configure do |cfg|
  cfg.flatten = true
  cfg.flatten_patterns = [
    /.*/
  ]
  cfg.dont_flatten_patterns = [
  ]
  cfg.colorize = true
  cfg.timeformat = '%Y/%m/%d %H:%M:%S'
  cfg.format = '[%T] (%S) %P %M'
end