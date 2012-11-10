require "machinist/active_record"

Project.blueprint do
  name { Faker::Name.name }
  max_builds { 1 }
  vcs_type { "git" }
  vcs_source { "test/files/repo" }
  vcs_branch { "master" }
  hook_update { true }
end

StepList.blueprint do
  name { Faker::Name.name }
  steps { "ls -al\ntrue" }
  project { Project.make }
end

Build.blueprint do
  project { Project.make }
  scheduled_at { Time.now }
  commit { "a" * 40 }
end
