require 'test_helper'

class TalkerHookTest < ActiveSupport::TestCase

  include WithTestRepo

  def setup
    super
    stub_request(:post, "http://www.example.com:443/rooms/1234/messages.json").
      with(:body => /repo/,
           :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'X-Talker-Token'=>'foobar'}).
      to_return(:status => 200, :body => "", :headers => {})

    Build.any_instance.stubs(:author).returns('Bob')
  end

  test "talker stating build passed" do
    project = talker_project_with_steps("ls .")
    hook = project.hooks.first
    assert_difference("Delayed::Job.count", +2) do # 1 job + 1 for sending the talker message
      job = project.build!
      job.invoke_job
    end
    build = project.recent_build
    jobs = run_delayed_jobs()

    talker = YAML.load(jobs.last.handler).perform
    assert_equal "Build '#{build.display_name}' in '#{project.name}' passed", talker[:message]
  end

  test "talker stating the build failed" do
    project = talker_project_with_steps("ls invalid_file_here")
    hook = project.hooks.first
    assert_difference("Delayed::Job.count", +2) do # 1 job + 1 for sending the talker message
      job = project.build!
      job.invoke_job
    end
    build = project.recent_build
    jobs = run_delayed_jobs()

    talker = YAML.load(jobs.last.handler).perform
    assert_equal "Build '#{build.display_name}' in '#{project.name}' failed", talker[:message]
  end

  # test "talker stating build is fixed" do
  #   project = talker_project_with_steps("ls invalid_file_here")
  #   hook = project.hooks.first
  #   project.build!
  #   run_delayed_jobs()
  #   project.step_lists.first.update_attributes!(:steps => "ls .")
  #   project.build!

  #   build = project.recent_build
  #   jobs = run_delayed_jobs()
  #   assert_equal 3, jobs.size # 1 project, 1 part, 1 talker message

  #   talker = YAML.load(jobs.last.handler).perform
  #   assert_equal "Build '#{build.display_name}' in '#{project.name}' fixed", talker[:message]
  # end

  private
    def talker_project_with_steps(steps)
      project = project_with_steps({
        :name => 'repo',
        :vcs_source => 'test/files/repo',
        :vcs_type => 'git',
        :max_builds => 2,
        :hooks => {"talker" => "talker"},
      }, steps)
      hook = project.hooks.first
      hook.configuration = {
        :room => '1234',
        :subdomain => 'www.example.com',
        :token => 'foobar',
        :use_ssl => 'true'
      }
      hook.save!
      project
    end
end
