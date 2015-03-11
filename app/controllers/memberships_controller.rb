class MembershipsController < ApplicationController

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
    if @membership.destroy
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was successfully destroyed."
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:role, :user_id)
  end

end
