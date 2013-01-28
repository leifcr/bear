source 'http://rubygems.org'

gem "rails", "3.2.11"

gem "haml"
gem "delayed_job"
gem 'delayed_job_active_record'
gem "stringex"
gem "open4"
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
# gem 'airbrake', '3.1.2'

# this must be outside assets, as the helpers are required all the time.
gem "twitter-bootstrap-rails"

group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'less-rails'
  gem 'uglifier', '>= 1.2.6'
  gem 'libv8', '3.11.8.13'
  gem 'therubyracer', '>= 0.11.3'
end

group :development do
  gem "thin"
  gem "wirble"
  gem "hirb"
  gem "awesome_print"
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'binding_of_caller'
  gem "better_errors"
  gem 'meta_request', '0.2.1'

  platforms :mri_19 do
    gem "ruby-debug19"
  end
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
  gem "bluepill", "~> 0.0.60"
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
