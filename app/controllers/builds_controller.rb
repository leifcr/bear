class BuildsController < ApplicationController

  def show
    @build = Build.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
    @build = Build.find(params[:id])
    unless @build.project.users.include?(current_user)
      flash[:error] = "You are not assigned to the project and cannot do: #{params[:action]}..."
      redirect_to build_path(@build)
    end    
    project = @build.project
    @build.destroy
    redirect_to project_path(project)
  end

end
