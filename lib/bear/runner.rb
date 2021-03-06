require 'open3'
module Bear
  class Runner
    def self.execute(dir, command, timeout = nil, shell = "zsh --login")
      timeout = ::Bear.timeout if timeout.nil? or timeout == 0
      # end_command = "#{command}"
      shell = find_available_shell if verify_shell(shell).nil? # safety catch, to find best 
      end_command = ""
      if Bear.config[:loadenv] == true
        homedir = Bear.config[:homedir]
        if File.exists?(File.join(File.expand_path(homedir), ".bash_profile"))
          end_command = "source #{File.join(File.expand_path(homedir), ".bash_profile")};"
        elsif File.exists?(File.join(File.expand_path(homedir), ".profile"))          
          end_command = "source #{File.join(File.expand_path(homedir), ".profile")};"
        end
      end
      end_command += "cd #{dir} && #{command};"
      Bear.logger.debug("Executing: '#{end_command}' with shell: '#{shell}'")

      with_clean_env(dir) do
        begin
          Timeout.timeout(timeout) do # 15 minutes default timeout
            @output = Output.new(dir, command)
            status = nil

            # use systememu, as we need a blocking runner. 
            status, stdout_str, stderr_str = systemu shell, :stdin => end_command
            # stdout_str, stderr_str, status = Open3.capture3(end_command)
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

    def self.verify_shell(shell)
      return nil if shell == nil or shell == ""
      s = shell.split(" ")
      if !s[0].nil? and s[0] != ""
        unless cross_which(s[0]).nil?
          return true if ["bash", "zsh", "sh", "csh", "ksh"].include?(s[0])
        end
      end
      nil
    end

    # Cross-platform way of finding an executable in the $PATH.
    # http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
    #
    #   which('ruby') #=> /usr/bin/ruby
    # Thanks mislav! 
    def self.cross_which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable? exe
        }
      end
      return nil
    end

    def self.find_available_shell
      return "zsh --login" unless self.cross_which("zsh")
      return "bash --login" unless self.cross_which("bash")
      return "sh -l" unless self.cross_which("sh")
      return "csh -l" unless self.cross_which("csh")
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
