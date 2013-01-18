module BigTuna
  class Hooks::Mailer < Hooks::Base
    NAME = "mailer"

    def build_passed(build, config)
      recipients = config["recipients"]
      Sender.delay.build_passed(build, recipients) unless recipients.blank?
    end

    def build_fixed(build, config)
      recipients = config["recipients"]
      Sender.delay.build_fixed(build, recipients) unless recipients.blank?
    end

    def build_failed(build, config)
      recipients = config["recipients"]
      Sender.delay.build_failed(build, recipients) unless recipients.blank?
    end

    class Sender < ActionMailer::Base
      self.append_view_path("lib/big_tuna/hooks")
      default :from => "ci-foo@foo.bar"

      def build_passed(build, recipients)
        @build = build
        @project = @build.project
        mail(:to => recipients, :subject => "Build PASSED! - '#{@build.display_name}' in '#{@project.name}'") do |format|
          format.text { render "mailer/build_passed" }
        end
      end

      def build_failed(build, recipients)
        @build = build
        @project = @build.project
        mail(:to => recipients, :subject => "Build FAILED! - '#{@build.display_name}' in '#{@project.name}'") do |format|
          format.text { render "mailer/build_failed" }
        end
      end

      def build_fixed(build, recipients)
        @build = build
        @project = @build.project
        mail(:to => recipients, :subject => "Build FIXED! - '#{@build.display_name}' in '#{@project.name}'") do |format|
          format.text { render "mailer/build_fixed" }
        end
      end
    end
  end
end
