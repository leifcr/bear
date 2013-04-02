module Bear
  VERSION = "0.5.0"

  DEFAULT_CONFIG = {
    "build_dir" => "builds",
    "timeout"   => 900,
    "url_host"  => "ci.zz-change-me.com"
  }

  extend self

  def config
    return @config if @config
    config = DEFAULT_CONFIG.dup
    if File.file?("config/bear.yml")
      config.merge!(YAML.load_file("config/bear.yml")[Rails.env] || {})
    end
    @config = config.symbolize_keys!
  end

  [:ajax_reload, :github_secure, :log, :bitbucket_secure, :build_dir, :read_only, :username, :password, :timeout].each do |key|
    define_method key do
      config[key]
    end
  end

  def logger
    @_logger ||= self.log ? Logger.new(self.log) : Rails.logger
  end

  def hooks
    @_hooks ||= []
  end

  def vcses
    @_vcses ||= []
  end

  def create_build_dir
    Dir.mkdir(File.join(Rails.root, self.build_dir), 0754) unless File.directory?(File.join(Rails.root, self.build_dir))
  end

  private
  def to_bool(value)
    return value if [true, false, nil].include?(value)
    if value.respond_to?(:to_s)
      return true if ['true', '1', 'yes', 'y'].include?(value.to_s.downcase)
      return false if ['false', '0', 'no', 'n', ''].include?(value.to_s.downcase)
    end
    raise ArgumentError, "unrecognized value #{value.inspect} for boolean"
  end
end
