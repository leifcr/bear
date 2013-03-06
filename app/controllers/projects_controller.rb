class ProjectsController < ApplicationController
  before_filter :locate_project, :only => [:show, :build, :edit, :update, :remove, :destroy, :arrange, :feed, :duplicate, :assignments]
  before_filter :verify_user, :only => [:build, :edit, :update, :remove, :destroy, :arrange, :duplicate, :assignments]
  respond_to :js, :only => [:index, :show]


  def index
    @projects = Project.order("position ASC")
  end

  def show
    @builds = @project.builds.order("created_at DESC").limit(@project.max_builds).includes(:project, :parts).all
  end

  def feed
    @builds = @project.builds.order("created_at DESC").limit(@project.max_builds)
    respond_to do |format|
      format.atom
    end
  end

  def build
    @project.build!
    redirect_to(project_path(@project))
  rescue Bear::VCS::Error => e
    flash[:error] = e.message
    redirect_to project_path(@project)
  end

  def duplicate
    project_clone = @project.duplicate_project
    redirect_to project_path(project_clone)
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    redirect_to project_path(@project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      @project.users << current_user
      redirect_to edit_project_path(@project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @project.update_attributes!(params[:project])
    flash[:success] = "Successfully updated #{@project.name} at #{@project.updated_at}"
    redirect_to edit_project_path(@project)
  end

  def assignments
    @users = User.all if !params[:projects]
    return render if request.get?
    if !params[:project][:user_ids] or params[:project][:user_ids] == "" or params[:project][:user_ids] == []
      flash[:error] = "No users selected"
      @users = User.all      
      return
    end
    uids = params[:project][:user_ids]
    uids.delete ""
    @users = User.find(uids)
    @project.users = @users
    redirect_to project_path(@project)
  end

  def remove
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  def arrange
    if params[:up]
      @project.move_higher
    elsif params[:down]
      @project.move_lower
    end
    redirect_to projects_path
  end

  private
  def locate_project
    @project = Project.find(params[:id])
  end
  
  def verify_user
    unless @project.users.include?(current_user)
      flash[:error] = "You are not assigned to the project and cannot do: #{params[:action]}..."
      redirect_to project_path(@project)
    end
  end
end
