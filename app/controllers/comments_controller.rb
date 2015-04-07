class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @task = Task.find(params[:task_id])
    @comment.user = current_user
    @comment.task = @task
    @project = Project.find(params[:project_id])
    if @comment.save
      redirect_to :back, notice: "Comment was successfully posted!"
    else
      flash.now[:alert] = "There was a problem posting your comment."
      render "tasks/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

end
