class UsersController < ApplicationController
  before_action :authenticate, except: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_collaborators, only: [:index, :show]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    unless current_user.admin?
      if current_user != @user
        raise AccessDenied
      end
      @submit_name = "Update User"
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    if @user.id == current_user.id
      session[:user_id] = nil
      @user.destroy
      redirect_to root_path, notice: "User was successfully deleted."
    else
      @user.destroy
      redirect_to users_path, notice: 'User was successfully deleted.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if current_user.admin?
        params.require(:user).permit(:first_name, :last_name, :email, :password, :admin)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end
    end

    def set_collaborators
      @collaborators = current_user.projects.flat_map{|project| project.users}
    end
end
