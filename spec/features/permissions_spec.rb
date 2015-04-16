require 'rails_helper'

describe 'Certain action and user memberships allow different permissions' do

  before :each do

    User.create(first_name: "admin", last_name: "example", email: "admin@example.com", password: "password", admin: true)
    @user = User.create(first_name: "Jake", last_name: "Marwil", email: "rjm02006@gmail.com", password: "password", admin: false)
    @project = Project.create(name: "Example Project")
    Membership.create(user_id: @user.id, project_id: @project.id, role: 1)
    visit "/signin"
    fill_in "Email", with: 'rjm02006@gmail.com'
    fill_in "Password", with: 'password'
    click_on 'Sign In!'
    expect(page).to have_content 'Welcome back, stranger!'

  end

  it 'when user logs in, directed to projects index' do
    expect(page).to have_content 'Example Project'
  end

end
