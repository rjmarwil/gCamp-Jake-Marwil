require 'rails_helper'


  describe 'User can CRUD tasks' do

    # Users can create a task.
    scenario 'User can create a task' do
      # visit tasks index
      visit '/tasks'

      # click on link to go to new task form
      click_on "New Task"

      #filling out form for task
      fill_in 'task[description]', :with => "Example task"


      #submitting form to create a task
      click_on "Create Task"

      #expect to see flash notice of successful creation of task
      expect(page).to have_content("Task was successfully created.")

      #expect page to show description of Example task
      expect(page).to have_content("Example task")

    end


    #Users can edit a task
    scenario 'User can edit a task' do

      @task = Task.create(:description => "Example task", :due_date => "2015-01-30")
      visit "/tasks"

      #click on Edit
      click_on "Edit"

      # change description field and update it to Example task edit
      fill_in 'task[description]', :with => "Example task edit"

      #submitting form to update a description in task
      click_on "Update Task"

      #expect to see flash notice of successful update of task
      expect(page).to have_content("Task was successfully updated.")

      #expect page to show updated description of Example task edit
      expect(page).to have_content("Example task edit")

  end


  # Users can show a task.
  scenario 'User can show a task' do

    @task = Task.create(:description => "Example task", :due_date => "2015-01-30")
    visit "/tasks"

    # click on task name link to go to task show page
    click_on "Example task"

    #expect page to show description and due date of Example task
    expect(page).to have_content("Example task")
    expect(page).to have_content("2015-01-30")

  end


  # Users can delete a task.
  scenario 'User can delete a task' do

    @task = Task.create(:description => "Example task", :due_date => "2015-01-30")
    visit "/tasks"

    #click on Delete
    click_on "Delete"

    #expect to see flash notice of successful deletion of task
    expect(page).to have_content("Task was successfully destroyed.")

  end


end
