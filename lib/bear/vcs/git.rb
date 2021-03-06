module Bear::VCS
  class Git < Base
    NAME = "Git"
    VALUE = "git"

    def self.supported?
      return @_supported unless @_supported.nil?
      begin
        @_supported = Bear::Runner.execute(Dir.pwd, "git --version").ok?
      rescue Bear::Runner::Error => e
        @_supported = false
      end
      @_supported &&= self.version_at_least?("1.5.1")
    end

    def self.version_at_least?(version)
      if @_version.nil?
        output = Bear::Runner.execute(Dir.pwd, "git --version").stdout.first
        @_version = output.match(/\d+\.\d+\.\d+/)[0].split(".").map { |e| e.to_i }
      end
      parts = version.split(".").map { |e| e.to_i }
      parts.each_with_index do |part, index|
        if part > @_version[index]
          return false
        elsif part < @_version[index]
          return true
        end
      end
      return true
    end

    def head_info
      command = "git log --max-count=1 --pretty=format:COMMITDATA:%H,%an,%ae,%ad,%s #{self.branch}"
      head_info_common(self.source, command)
    end

    def clone(where_to)
      if self.class.version_at_least?("1.6.5")
        command = "git clone --branch #{self.branch} --depth 1 #{self.source} #{where_to}"
      else
        command = "mkdir -p #{where_to} && cd #{where_to} && git init && git pull #{self.source} #{self.branch} && git branch -M master #{self.branch}"
      end
      Bear::Runner.execute(Dir.pwd, command)
    end
    
    def update(where_to)
      command = 'git clean -fd && git pull'
      Bear::Runner.execute(where_to, command)
    end
  end
end
