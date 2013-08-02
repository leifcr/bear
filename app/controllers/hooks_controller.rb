class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :authenticate_user!

  def autobuild
    project = Project.where(:hook_name => params[:hook_name]).first
    if project
      trigger_and_respond(project)
    else
      render :text => "hook name %p not found" % [params[:hook_name]], :status => 404
    end
  end

  def github
    payload             = JSON.parse(params[:payload])
    branch              = payload["ref"].split("/").last
    github_project_path = payload["repository"]["url"].match( %r{github\.com/(.*)} )[1]
    search_term         = "%github.com_#{github_project_path}.git"

    unless payload["commits"].nil?
      if payload["commits"].length > 0
        if payload["commits"].last["message"].include?("[ci skip]")
          render :text => "Told to skip testing/ci'ing this commit", :status => 200
          return
        end
      end
    end

    projects = Project.where(["vcs_source LIKE ?", search_term]).where(:vcs_branch => branch).all

    if Bear.github_secure.nil?
      render :text => "github secure token is not set up", :status => 403
    elsif projects.present? && params[:secure] == Bear.github_secure
      trigger_and_respond(projects)
    elsif projects.empty?
      render :text => "project not found", :status => 404
    else
      render :text => "invalid secure token", :status => 403
    end
  end

  def bitbucket
    payload  = JSON.parse(params[:payload])
    branches = Array.new
    # get branches
    payload["commits"].each do |commit|
      branches.push commit["branch"] if (commit["branch"] != nil)
    end

    # If there are no branches, assume there was a merge to master
    branches.push "master" unless branches.length > 0

    unless payload["commits"].nil?
      if payload["commits"].length > 0
        if payload["commits"].last["message"].include?("[ci skip]")
          render :text => "Told to skip testing/ci'ing this commit", :status => 200
          return
        end
      end
    end
    if (payload["repository"]["scm"] == "git")
      source = "git@bitbucket.org:#{payload["repository"]["owner"]}/#{payload["repository"]["slug"]}.git"
    else
      source = "ssh://hg@bitbucket.org#{payload["repository"]["absolute_url"]}"
    end

    projects = Project.where(:vcs_source => source).where(:vcs_branch => branches).all

    if Bear.bitbucket_secure.nil?
      render :text => "bitbucket secure token is not set up", :status => 403
    elsif projects and params[:secure] == Bear.bitbucket_secure
      trigger_and_respond(projects)
    else
      render :text => "invalid secure token", :status => 404
    end
  end

  def configure
    @project = Project.find(params[:project_id])
    @hook = Hook.where(:project_id => @project.id, :hook_name => params[:name]).first
    return render if request.get?
    @hook.configuration = params["hook"]["configuration"]
    @hook.hooks_enabled = (params["hook"]["hooks_enabled"] || {}).keys
    @hook.save!
    flash[:success] = "Successfully updated configuration for #{@project.name} - #{@hook.hook_name.humanize} at #{@hook.updated_at}"
    redirect_to(project_config_hook_path(@project, @hook.backend.class::NAME))
  end

  private
  def trigger_and_respond(projects)
    projects.each(&:build!)
    render :text => "build for the following projects were triggered: " +
      projects.map(&:name).map(&:inspect).join(', '), :status => 200
  end
end
