require "integration_test_helper"

module BigTuna
  class Hooks::NoConfig
    NAME = "no_config"
  end
end

class HooksTest < ActionController::IntegrationTest

  include WithTestRepo

  test "hooks config renders hook config partial if it's present" do
    project = project_with_steps({
      :name => "Koss",
      :vcs_source => "test/files/repo",
      :max_builds => 2,
      :hooks => {"mailer" => "mailer"},
    }, "ls")
    login_as project.users.first, scope: :user
    visit edit_project_path(project)
    within("#hook_mailer") do
      click_link "Configure"
    end
    assert page.has_content?("Recipients"), "Page has Recipients"
    assert page.has_field?("Build still fails"), "Page has field Build still fails"
    assert page.has_xpath?("//*[@name='hook[hooks_enabled][build_still_fails]' and @checked='checked']"), "Build still fails is checked"
    #//*[@id="hook_hooks_enabled_build_still_fails"]
    uncheck "Build still fails"
    click_button "Update"
    assert ! page.has_xpath?("//*[@name='hook[hooks_enabled][build_still_fails]' and @checked='checked']"), "Build still fails isn't checked"
  end

  test "hooks with no config work as usually" do
    with_hook_enabled(BigTuna::Hooks::NoConfig) do
      project = project_with_steps({
        :name => "Koss",
        :vcs_source => "test/files/repo",
        :max_builds => 2,
        :hooks => {"no_config" => "no_config"},
      }, "ls")
      login_as project.users.first, scope: :user
      visit edit_project_path(project)
      within("#hook_no_config") do
        click_link "Configure"
      end
      assert_status_code 200
    end
  end

  test "xmpp hook has a valid configuration form" do
    project = project_with_steps({
      :name => "Koss",
      :vcs_source => "test/files/repo",
      :max_builds => 2,
      :hooks => {"xmpp" => "xmpp"},
    }, "ls")

    login_as project.users.first, scope: :user
    visit edit_project_path(project)
    within("#hook_xmpp") do
      click_link "Configure"
    end
    assert page.has_field?("hook_configuration_sender_full_jid")
    assert page.has_field?("hook_configuration_sender_password")
    assert page.has_field?("hook_configuration_recipients")
    click_button "Update"
    assert_status_code 200
  end

  test "irc hook has a valid configuration form" do
    project = project_with_steps({
      :name => "Koss",
      :vcs_source => "test/files/repo",
      :max_builds => 2,
      :hooks => {"irc" => "irc"},
    }, "ls")

    login_as project.users.first, scope: :user
    visit edit_project_path(project)
    within("#hook_irc") do
      click_link "Configure"
    end
    assert page.has_field?("hook_configuration_user_name")
    assert page.has_field?("hook_configuration_user_password")
    assert page.has_field?("hook_configuration_server")
    assert page.has_field?("hook_configuration_port")
    assert page.has_field?("hook_configuration_room")
    assert page.has_field?("hook_configuration_room_password")
    
    click_button "Update"
    assert_status_code 200
  end
end
