source 'http://rubygems.org'

gem "rails", "~> 3.2.13"
gem "haml"
gem "delayed_job"
gem 'delayed_job_active_record'
gem "delayed_job_web", :git => "git://github.com/leifcr/delayed_job_web.git"

gem "stringex"
# gem "open4"
gem 'systemu',  :git => 'git://github.com/leifcr/systemu.git'
gem "json"
gem "jquery-rails"
gem 'acts_as_list'
gem 'devise'
gem 'simple_form'

# gem 'newrelic_rpm'

# ruby 1.9 compatible version
gem "scashin133-xmpp4r-simple", '0.8.9', :require => 'xmpp4r-simple'

# irc notification
gem "shout-bot"

# campfire notifications
gem "tinder"

gem 'mysql2', '~> 0.3.10'

# Error Tracking
gem 'airbrake'

group :assets do
  gem 'therubyracer'
  gem 'execjs'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'less-rails'
  gem 'uglifier', '>= 1.2.6'
end

# this must be outside assets, as the helpers are required all the time.
gem "twitter-bootstrap-rails"

group :development do
  gem "thin"
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-pumaio'
  gem 'capistrano-delayed_job'
  gem 'binding_of_caller'
  gem "better_errors"
  gem 'meta_request', '>= 0.2.1'
  gem 'awesome_print'
  gem 'wirble'
  gem 'hirb'
  # platforms :mri_19 do
  #   gem "ruby-debug19"
  # end
end

group :test do
  gem "capybara"
  gem "launchy"
  gem "faker"
  gem "machinist"
  gem "nokogiri"
  gem "mocha", :require => false
  gem "crack"
end

group :production do
  gem "puma"
end

group :test do
  gem "webmock"
  gem "database_cleaner"
end

# better logging in development and production
group :development, :production do
  gem 'grizzled-rails-logger'
end
