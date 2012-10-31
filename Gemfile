source 'http://rubygems.org'

gem "rails", "3.2.1"

gem "haml"
gem "delayed_job"
gem 'delayed_job_active_record'
gem "stringex"
gem "open4"
gem "json"
gem "jquery-rails"
gem "thin"
gem 'acts_as_list'

gem 'newrelic_rpm'

# ruby 1.9 compatible version
gem "scashin133-xmpp4r-simple", '0.8.9', :require => 'xmpp4r-simple'

# irc notification
gem "shout-bot"

# notifo notifications
gem "notifo"

# campfire notifications
gem "tinder"

gem 'mysql2', '~> 0.3.10'

# Error Tracking
gem 'airbrake', '3.1.2'

group :development, :test do
  gem "capybara"
  gem "launchy"
  gem "faker"
  gem "machinist"
  gem "nokogiri"
  gem "mocha"
  gem "database_cleaner"
  gem "crack"

  platforms :mri_18 do
    gem "ruby-debug"
  end

  platforms :mri_19 do
    gem "ruby-debug19"
  end
end

group :test do
  gem "webmock"
end
