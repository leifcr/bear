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
      info = {}
      command = "hg log --limit 1 --rev #{self.branch} --template='{node}\n{author|person}\n{author|email}\n{date|date}\n{desc}'"
      begin
        output = Bear::Runner.execute(self.source, command)
      rescue Bear::Runner::Error => e
        raise VCS::Error.new("Couldn't access repository log")
      end
      head_hash = output.stdout
      info[:commit] = head_hash.shift
      info[:author] = head_hash.shift
      info[:email] = head_hash.shift
      info[:committed_at] = Time.parse(head_hash.shift)
      info[:commit_message] = head_hash.join("\n")
      [info, command]
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
