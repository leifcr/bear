class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  self.append_view_path("lib/bear/hooks")
  protect_from_forgery

end
