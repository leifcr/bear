class ApplicationController < ActionController::Base
	before_filter :authenticate

  self.append_view_path("lib/big_tuna/hooks")
  protect_from_forgery

  protected

  	def authenticate
  		authenticate_or_request_with_http_basic do |username, password|
  			username == BigTuna.username && password == BigTuna.password
  		end
  	end
end
