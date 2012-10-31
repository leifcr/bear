Airbrake.configure do |config|
	config.api_key		= '0478227a3c4d67e640cc47d1b8de291a'
	config.host				= 'errors.developercity.co.uk'
	config.port				= 80
	config.secure			= config.port == 443
end