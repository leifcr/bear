module Bear::VCS
  class Mercurial < Base
    NAME = "Mercurial"
    VALUE = "hg"

    def self.supported?
      return @_supported unless @_supported.nil?
      begin
        @_supported = Bear::Runner.execute(Dir.pwd, "hg --version").ok?
      rescue Bear::Runner::Error => e
        @_supported = false
      end
      @_supported
    end

    def head_info
      command = "hg log --limit 1 --rev #{self.branch} --template='COMMITDATA:{node},{author|person},{author|email},{date|date},{desc}'"
      head_info_common(self.source, command)
    end

    def clone(where_to)
      command = "hg clone -u #{self.branch} #{self.source} #{where_to}"
      Bear::Runner.execute(Dir.pwd, command)
    end

    def update(where_to)
      command = "hg pull -u"
      Bear::Runner.execute(where_to, command)
    end
  end
end
