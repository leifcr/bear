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
    project = @build.project
    @build.destroy
    redirect_to project_path(project)
  end

end
