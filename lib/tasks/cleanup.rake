task :cleanup => :environment do
  desc "fix invalid data"

  # Removes any memberships with a null project_id or user_id
  Membership.all.each do |membership|
    membership.destroy if memebership.user_id.nil? or membership.project_id.nil?
  end

  # Removes all memberships where their users have already been deleted
  User.all.each do |user|
    Membership.where.not(user_id: user.id).destroy_all
  end

  # Removes all memberships where their projects have already been deleted
  Project.all.each do |project|
    Membership.where.not(project_id: project.id).destroy_all
  end

  # Removes any tasks with null project_id
  Task.where(project_id: nil).destroy_all

  # Removes all tasks where their projects have been deleted
  Project.all.each do |project|
    Task.where.not(project_id: project.id).destroy_all
  end

  # Removes any comments with a null task_id
  Comment.where(task_id: nil).destroy_all

  # Removes all comments where their tasks have been deleted
  Task.all.each do |task|
    Comment.where.not(task_id: task.id).destroy_all
  end

  # Sets the user_id of comments to nil if their users have been deleted
  # User.all.each do |user|
  #   Comment.find_by.not(user_id: user.id).user_id = nil
  # end

end
