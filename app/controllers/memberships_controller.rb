class MembershipsController < ApplicationController
  before_action :check_membership
  before_action :check_owner, only: [:edit, :update]

  def index
    @memberships = Membership.all
    @membership = Membership.new
    @project = Project.find(params[:project_id])
  end

  def new
    @membership = Membership.new
    @project = Project.find(params[:project_id])
  end

  def create
    @membership = Membership.new(membership_params)
    @project = Project.find(params[:project_id])
    @membership.project_id = @project.id
    @membership.user_id
      if @membership.save
        redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully added."
      else
        render :index
      end
  end

  def update
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully updated."
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @membership = Membership.find(params[:id])
    if current_user.last_project_owner?(@project) && current_user.id == @membership.id
       redirect_to project_memberships_path(@project), :alert => 'Projects must have at least one owner.'
    else
      @membership.destroy
      redirect_to projects_path, notice: "#{@membership.user.full_name} was successfully destroyed."
    end
  end

  private

  def check_membership
    @project = Project.find(params[:project_id])
    unless @project.users.include? current_user
      redirect_to projects_path, notice: 'You do not have access to that project.'
    end
  end

  def check_owner
    unless current_user.project_owner?(@project)
      redirect_to project_path(@project), alert: 'You do not have access.'
    end
  end

  def membership_params
    params.require(:membership).permit(:role, :user_id)
  end

end
