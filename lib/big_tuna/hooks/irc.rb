require 'lib/shout-bot' # note : this should be updated in newer versions
module BigTuna
  class Hooks::Irc < Hooks::Base
    NAME = "irc"

    def build_passed(build, config)
      project = build.project
      Delayed::Job.enqueue(Job.new(config, "New build in '#{project.name}' PASSED (#{build_url(build)})"))
    end

    def build_fixed(build, config)
      project = build.project
      Delayed::Job.enqueue(Job.new(config, "New build in '#{project.name}' FIXED (#{build_url(build)})"))
    end

    def build_failed(build, config)
      project = build.project
      Delayed::Job.enqueue(Job.new(config, "New build in '#{project.name}' FAILED (#{build_url(build)})"))
    end

    class Job
      def initialize(config, message)
        @config = config
        @message = message
      end

      def perform
        return if Rails.env.test? # shouldn't shout out when testing...
        uri = "irc://#{@config[:user_name]}"
        uri += ":#{@config[:user_password]}" if @config[:user_password].present? and @config[:user_password] != ""
        uri += "@#{@config[:server]}:#{@config[:port].present? ? @config[:port] : '6667'}"
        uri += "/##{@config[:room].to_s.gsub("#","") }"
        if @config[:room_password] and @config[:room_password] != ""
          ::ShoutBot.shout(uri, @config[:room_password]) { |channel| channel.say @message }
        else
          ::ShoutBot.shout(uri) { |channel| channel.say @message }          
        end
      end
    end
  end
end
