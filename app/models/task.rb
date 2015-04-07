class Task < ActiveRecord::Base

  validates :description, presence: true

  belongs_to :project
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments

end
