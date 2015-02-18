class User < ActiveRecord::Base

  def full_name
    first_name + " " + last_name
  end

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_secure_password

end
