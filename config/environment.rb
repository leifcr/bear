# Load the rails application
require File.expand_path('../application', __FILE__)

# load bear module before init so init can use the settings
require File.expand_path('../../lib/bear', __FILE__)

# Initialize the rails application
Bear::Application.initialize!
