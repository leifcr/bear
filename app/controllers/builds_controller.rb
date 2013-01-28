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

  def output
    @build = Build.find(params[:id])
    params[:path] = "" if (params[:path] == nil)
    # check if path exists, else redirect back one step
    unless Dir.exists?(File.join(@build.build_dir, params[:path])) && (Dir.exists?(@build.build_dir_public))
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to :show, :notice => "The output path #{File.join(@build.build_dir_public, params[:path]).to_s} doesn't exist."
      end
      return
    end
    # @files = Dir.glob(File.join(@build.build_dir, path, '*'))
    @dirs = Dir.glob(File.join(@build.build_dir_public, params[:path], '*/'))
    @files = Dir.glob(File.join(@build.build_dir_public, params[:path], '*'))
  end

end
