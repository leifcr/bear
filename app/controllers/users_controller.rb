class UsersController < ApplicationController
  # before_filter :authenticate_user!

  def index
    @users = User.all
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.create(params[:user])
    if @user.errors.count > 0
      @users = User.all
      render :index
      return
    end

    redirect_to users_path
  end

  def update
    current_user.update_attributes(params[:user])

    redirect_to :back
  end

  def destroy
    User.find(params[:id]).destroy

    redirect_to users_path
  end
end