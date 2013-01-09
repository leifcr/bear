class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
	# before_filter :authenticate

  self.append_view_path("lib/big_tuna/hooks")
  protect_from_forgery

  protected

  	# def authenticate
   #    return if Rails.env.development? || Rails.env.test?
  	# 	authenticate_or_request_with_http_basic do |username, password|
  	# 		username == BigTuna.username && password == BigTuna.password
  	# 	end
  	# end
end
