module Bear::Hooks
  class Base
    include Rails.application.routes.url_helpers

    def self.inherited(klass)
      Bear.hooks << klass
      Bear.logger.info("Registered hook: %s" % [klass])
    end

    def default_url_options
      ActionMailer::Base.default_url_options
    end
  end
end
