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
    unless Dir.exists?(File.join(@build.build_dir, @build.project.output_path, params[:path])) && (Dir.exists?(@build.build_dir_public))
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to :show, :notice => "The output path #{File.join(@build.build_dir_public, params[:path]).to_s} doesn't exist."
      end
      return
    end
    build_dirs_and_files("output", params[:path])
  end

  def log
    @build = Build.find(params[:id])
    params[:path] = "" if (params[:path] == nil)
    # check if path exists, else redirect back one step
    unless Dir.exists?(File.join(@build.build_dir, @build.project.log_path, params[:path])) && (Dir.exists?(@build.build_dir_public))
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to :show, :notice => "The log path #{File.join(@build.build_dir_public, params[:path]).to_s} doesn't exist."
      end
      return
    end
    build_dirs_and_files("log", params[:path])
  end

  private

  def build_dirs_and_files(folder, params_path)
    @dirs = Array.new
    @files = Array.new
    Dir.glob(File.join(@build.build_dir_public, folder, params_path, '*/')).sort.each do |dir|
      single_dir = Hash.new
      single_dir[:basename] = File.basename(dir)
      single_dir[:url]      = "/builds/#{folder}/#{@build.id}#{dir.gsub(File.join(@build.build_dir_public, folder).to_s, "")}"
      single_dir[:date]     = File.mtime(dir)
      @dirs.push single_dir
    end

    Dir.glob(File.join(@build.build_dir_public, folder, params_path, '*')).sort.each do |file|
      unless File.directory?(file)
        single_file = Hash.new
        single_file[:basename] = File.basename(file)
        single_file[:url]      = "/" + file.gsub(Rails.root.to_s + "/public/", "")
        single_dir[:date]      = File.mtime(file)
        @files.push single_file
      end
    end

  end

end
