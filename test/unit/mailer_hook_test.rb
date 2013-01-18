require 'test_helper'

class MailerHookTest < ActiveSupport::TestCase

  include WithTestRepo

  test "mail is sent when build the build is ok" do
    project = mailing_project_with_steps("ls .")
    project.build!
    ran_jobs = run_delayed_jobs()
    assert_equal 1, find_ran_mail_jobs(ran_jobs, "build_passed")
    assert_equal 3, ran_jobs.size
  end

  test "mail stating that build failed is sent when build failed" do
    project = mailing_project_with_steps("ls invalid_file_here")
    project.build!
    jobs = run_delayed_jobs()
    assert_equal 1, find_ran_mail_jobs(jobs, "build_failed")
    # assert_equal 3, jobs.size # 1 project, 1 part, 1 mail
    build = project.recent_build
    job = jobs.last
    mail = YAML.load(job.handler).perform
    assert_equal "Build FAILED! - '#{build.display_name}' in '#{project.name}'", mail.subject
    assert ! mail.body.to_s.blank?
  end

  # test "mail stating that build is back to normal is sent when build fixed" do
  #   project = mailing_project_with_steps("ls invalid_file_here")
  #   project.build!
  #   jobs = run_delayed_jobs()
  #   assert_equal 1, find_ran_mail_jobs(jobs, "build_failed")
  #   project.step_lists.first.update_attributes!(:steps => "ls .")
  #   project.build!
  #   jobs = run_delayed_jobs()
  #   assert_equal 1, find_ran_mail_jobs(jobs, "build_fixed")

  #   build = project.recent_build
  #   job = jobs.last
  #   mail = YAML.load(job.handler).perform
  #   assert_equal "Build FIXED! - '#{build.display_name}' in '#{project.name}'", mail.subject
  #   assert ! mail.body.to_s.blank?
  # end

  # TODO: add option to select email types on hook
  # test "mail is not sent when build is ok but was ok before" do
  #   project = mailing_project_with_steps("ls .")
  #   project.build!
  #   run_delayed_jobs()
  #   project.build!
  #   ran_jobs = run_delayed_jobs()
  #   assert_equal 2, ran_jobs.size
  # end

  def mailing_project_with_steps(steps)
    project = project_with_steps({
       :name => "repo",
       :vcs_source => "test/files/repo",
       :max_builds => 2,
       :hooks => {"mailer" => "mailer"},
    }, steps)
    hook = project.hooks.first
    hook.configuration = {"recipients" => "bigtunatest@mailinator.com"}
    hook.save!
    project
  end

  def find_ran_mail_jobs(ran_jobs, mail_method)
    found_mail_jobs = 0
    ran_jobs.each do |job|
      if (job.handler.include?("BigTuna::Hooks::Mailer::Sender"))
        found_mail_jobs += 1 if job.handler.include?("method_name: :#{mail_method}")
      end
    end
    found_mail_jobs
  end

end
