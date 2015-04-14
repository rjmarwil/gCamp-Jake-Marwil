class User < ActiveRecord::Base

  def full_name
    first_name + " " + last_name
  end

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :comments
  has_many :tasks, through: :comments

  has_secure_password

  def project_owner?(project)
    project.memberships.find_by(role: Membership.roles[:owner], user_id: id)
  end

  def last_project_owner?(project)
    project.memberships.where(role: Membership.roles[:owner]).count == 1 && project_owner?(project)
  end

end
