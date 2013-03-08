module Bear::VCS
  class Base
    attr_reader :source, :branch

    def initialize(source, branch)
      @source = source
      @branch = branch
    end

    def self.supported?
      raise ArgumentError.new("Implement ::supported? method")
    end

    def head_info_common(dir, command)
      info = {}      
      begin
        output = Bear::Runner.execute(dir, command)
      rescue Bear::Runner::Error => e
        raise Bear::VCS::Error.new("Couldn't access repository log")
      end
      output.stdout.each do |stdout_line|
        if stdout_line.start_with?("COMMITDATA:")
          commit_data = stdout_line.gsub("COMMITDATA:", "").split(",")
          if commit_data.length != 5 
            raise Bear::VCS::Error.new("Couldn't access repository log") 
          else
            info[:commit]         = commit_data[0]
            info[:author]         = commit_data[1]
            info[:email]          = commit_data[2]
            info[:committed_at]   = Time.parse(commit_data[3])
            info[:commit_message] = commit_data[4]
          end
        end
      end
      [info, command]      
    end

    def self.inherited(klass)
      Bear.vcses << klass
      Bear.logger.info("Registered VCS: %s" % [klass])
    end
    
    def support_incremental_build?
      respond_to?(:update)
    end
  end
end
