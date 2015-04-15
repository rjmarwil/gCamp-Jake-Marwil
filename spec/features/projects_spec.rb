require 'rails_helper'


  describe 'User can CRUD projects' do

    before :each do

      a = User.create(first_name: "Jake", last_name: "Marwil", email: "rjm02006@gmail.com", password: "password", admin: true)
      visit "/"
      click_on 'Sign In'
      fill_in "Email", with: 'rjm02006@gmail.com'
      fill_in "Password", with: 'password'
      click_on "Sign In!"

      b = Project.create(name: "Example project")
      Membership.create(user_id: a.id, project_id: b.id, role: 1)
      visit '/projects'

    end

    # Users can create a project.
    scenario 'User can create a project' do

      # click on link to go to new project form
      first(:link, "New Project").click

      #filling out form for project
      fill_in 'project[name]', :with => "Example project"


      #submitting form to create a project
      click_on "Create Project"

      #expect to see flash notice of successful creation of project
      expect(page).to have_content("Project was successfully created.")

      #expect page to show description of Example project
      expect(page).to have_content("Example project")

    end


    #Users can edit a project
    scenario 'User can edit a project' do

      #click on Edit
      click_on "Edit"

      # change description field and update it to Example project edit
      fill_in 'project[name]', :with => "Example project edit"

      #submitting form to update a description in project
      click_on "Update Project"

      #expect to see flash notice of successful update of project
      expect(page).to have_content("Project was successfully updated.")

      #expect page to show updated description of Example project edit
      expect(page).to have_content("Example project edit")

  end


  # Users can show a project.
  scenario 'User can show a project' do

    # click on project name link to go to project show page
    first(:link, "Example project").click

    #expect page to show description and due date of Example project
    expect(page).to have_content("Example project")

  end


  # Users can delete a project.
  scenario 'User can delete a project' do

    # click on project name link to go to project show page
    first(:link, "Example project").click

    #click on Delete
    click_on "Delete"

    #expect to see flash notice of successful deletion of project
    expect(page).to have_content("Project was successfully destroyed.")

  end


end
