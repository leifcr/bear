Dir[File.join(Rails.root, "lib", "bear", "vcs", "*.rb")].each { |vcs| require_dependency(vcs) }
Dir[File.join(Rails.root, "lib", "bear", "hooks", "*.rb")].each { |hook| require_dependency(hook) }

Bear.create_build_dir
