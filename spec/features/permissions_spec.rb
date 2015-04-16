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
    expect(page).to have_content 'You have successfully signed in'

  end

  it 'when user logs in, directed to projects index' do
    expect(page).to have_content 'Example Project'
  end

  it 'users who sign up are taken to project/new page' do
    click_on 'Sign Out'
    click_on 'Sign Up'
    fill_in "user[first_name]", with: 'Bobo'
    fill_in "user[last_name]", with: 'Johnson'
    fill_in "user[email]", with: 'a@a.com'
    fill_in "user[password]", with: 'a'
    fill_in "user[password_confirmation]", with: 'a'
    click_on "Sign Up!"
    expect(page).to have_content "New Project"
    expect(page).to have_content "Cancel"
  end

  it 'redirects to tasks index after project creation' do
    visit "/projects/new"
    fill_in "name", with:  "Example"
    click_on "Create Project"
    expect(page).to have_content "Project was successfully created"
    expect(page).to have_content "Tasks for Example"
    expect(page).to have_content "Description"
  end

  it 'sets creator of project as owner' do
    visit "/projects/new"
    fill_in "name", with:  "Example"
    click_on "Create Project"
    first(:link, "Example").click
    click_on "Memberships"
    expect(page).to have_content 'Jake Marwil'
    expect(page).to have_content 'Owner'
    expect(page).to have_content 'You are the last owner'
  end

  it 'a user can view projects they created' do
    visit "/projects/new"
    fill_in "name", with:  "Example"
    click_on "Create Project"
    first(:link, "Example").click
    expect(page).to have_content 'Example'
    expect(page).to have_content 'Edit'
    expect(page).to have_content 'Delete'
  end

  it 'a user can view projects they are a member of' do
    # create a second project
    @project2 = Project.create(name: "Example Project 2")
    # assign @user to second project only as a member (role: 0)
    Membership.create(user_id: @user.id, project_id: @project2.id, role: 0)
    visit "/projects"
    expect(page).to have_content 'Example Project 2'
    first(:link, 'Example Project 2').click
    expect(page).to have_content 'Example Project 2'
    click_on "Memberships"
    expect(page).to have_content 'Jake Marwil'
    expect(page).to have_content 'Member'
  end

  it 'a user cannot view edit/delete actions for projects they are only a member of' do
    @project2 = Project.create(name: "Example Project 2")
    Membership.create(user_id: @user.id, project_id: @project2.id, role: 0)
    visit "/projects"
    expect(page).to have_content 'Example Project 2'
    first(:link, 'Example Project 2').click
    expect(page).not_to have_content 'Edit'
    expect(page).not_to have_content 'Delete'
  end

  it "a user cannot view projects they didn't create and aren't members of" do
    @project2 = Project.create(name: "Example Project 2")
    visit "/projects"
    expect(page).not_to have_content 'Example Project 2'
    visit "/projects/#{@project2.id}"
    expect(page).to have_content 'You do not have access to that project'
  end

  it "a user cannot see memberships for projects they aren't assigned to" do
    @project2 = Project.create(name: "Example Project 2")
    visit "/projects/#{@project2.id}/memberships"
    expect(page).to have_content 'You do not have access to that project'
  end

  it 'project owners can see edit and delete buttons' do
    visit '/projects/new'
    fill_in 'name', with: 'Example Project 2'
    click_button 'Create Project'
    first(:link, "Example Project 2").click
    expect(page).to have_content "Edit"
    click_on 'Edit'
    fill_in "name", with: "Example Project 2 edit"
    click_on "Update Project"
    expect(page).to have_content "Project was successfully updated."
    click_on "Delete"
    expect(page).to have_content  "Project was successfully destroyed."
  end

  it 'normal users can see their own emails' do
    click_on 'Users'
    expect(page).to have_content 'rjm02006@gmail.com'
  end

  it 'normal users can see emails of users who are assigned to their projects' do
    @user2 = User.create(first_name: "Fake", last_name: "User", email: "a@a.com", password: "password", admin: false)
    Membership.create(user_id: @user2.id, project_id: @project.id, role: 0)
    click_on 'Users'
    expect(page).to have_content 'a@a.com'
  end

  it 'normal users cannot see emails of users who are not assigned to their projects' do
    User.create(first_name: "Fake", last_name: "User", email: "a@a.com", password: "password", admin: false)
    @project2 = Project.create(name: "Example Project 2")
    click_on 'Users'
    expect(page).not_to have_content 'a@a.com'
  end

  it 'admin users can see all user emails' do
    User.create(first_name: "Fake", last_name: "User", email: "a@a.com", password: "password", admin: false)
    click_on 'Sign Out'
    click_on 'Sign In'
    fill_in "Email", with: 'admin@example.com'
    fill_in "Password", with: 'password'
    click_on 'Sign In!'
    click_on 'Users'
    expect(page).to have_content 'a@a.com'
    expect(page).to have_content 'rjm02006@gmail.com'
    expect(page).to have_content 'admin@example.com'
  end

  it "user cannot see other user emails on their show pages" do
    visit '/users'
    click_on "admin example"
    expect(page).to_not have_content 'admin@example.com'
  end

  it 'when admin creates user, they can make them admin with a checkbox' do
    click_on 'Sign Out'
    click_on 'Sign In'
    fill_in "Email", with: 'admin@example.com'
    fill_in "Password", with: 'password'
    click_on 'Sign In!'
    click_on 'Users'
    click_on 'New User'
    expect(page).to have_content 'Admin'
  end

end
