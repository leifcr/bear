require 'open3'
module BigTuna
  class Runner
    def self.execute(dir, command, timeout = nil)
      timeout = ::BigTuna.timeout if timeout.nil? or timeout == 0
      end_command = "cd #{dir} && #{command}"
      BigTuna.logger.debug("Executing: #{end_command}")
      with_clean_env(dir) do
        begin
          Timeout.timeout(timeout) do # 15 minutes default timeout
            @output = Output.new(dir, command)
            status = nil
            stdout_str, stderr_str, status = Open3.capture3(end_command)
            @output.append_stdout(stdout_str)
            @output.append_stderr(stderr_str)

            if status != nil
              @output.finish(status.exitstatus)
            else
              @output.finish(-1)
            end
            raise Error.new(@output) if @output.exit_code != 0
            @output
          end
        rescue Timeout::Error => e
          @output.finish(999)
          raise Error.new(@output) if @output.exit_code != 0
          @output
        end
      end
    end

    def self.with_clean_env(dir)
      Bundler.with_clean_env do
        begin
          rails_env = ENV.delete("RAILS_ENV")
          old_bundle_gemfile = nil
          bundle_gemfile = File.join(dir, "Gemfile")
          if File.file?(bundle_gemfile)
            old_bundle_gemfile = ENV.delete("BUNDLE_GEMFILE")
            ENV["BUNDLE_GEMFILE"] = bundle_gemfile
          end
          yield
        ensure
          ENV["RAILS_ENV"] = rails_env if rails_env # if nil, then don't set any key
          ENV["BUNDLE_GEMFILE"] = old_bundle_gemfile if old_bundle_gemfile
        end
      end
    end

    class Error < Exception
      attr_reader :output

      def initialize(output)
        @output = output
      end

      def message
        if @output.exit_code == 999
          "Timeout error (#{@output.exit_code}) executing '#{@output.command}' in '#{@output.dir}'"
        else
          "Error (#{@output.exit_code}) executing '#{@output.command}' in '#{@output.dir}'"
        end
      end
    end
  end
end
