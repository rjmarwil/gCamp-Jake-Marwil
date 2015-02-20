require 'rails_helper'


  describe 'User can CRUD users' do

    # Users can create a user.
    scenario 'User can create a user' do

      # visit users index
      visit '/users'

      # click on link to go to new user form
      click_on "New User"

      #filling out form for user
      fill_in 'user[first_name]', :with => "A"
      fill_in 'user[last_name]', :with => "A"
      fill_in 'user[email]', :with => "a@a.com"
      fill_in 'user[password]', :with => "a"
      fill_in 'user[password_confirmation]', :with => "a"


      #submitting form to create a user
      click_on "Create User"

      #expect to see flash notice of successful creation of user
      expect(page).to have_content("User was successfully created.")

      #expect page to show description of Example user
      expect(page).to have_content("A A")

    end


    #Users can edit a user
    scenario 'User can edit a user' do

      @user = User.create(:first_name => "A", :last_name => "A", :email => "a@a.com", :password => "a", :password_confirmation => "a")
      visit "/users"

      #click on Edit
      click_on "Edit"

      # change description field and update it to Example user edit
      fill_in 'user[first_name]', :with => "Example user edit"

      #submitting form to update a description in user
      click_on "Update User"

      #expect to see flash notice of successful update of user
      expect(page).to have_content("User was successfully updated.")

      #expect page to show updated description of Example user edit
      expect(page).to have_content("Example user edit")

  end


  # Users can show a user.
  scenario 'User can show a user' do

    @user = User.create(:first_name => "A", :last_name => "A", :email => "a@a.com", :password => "a", :password_confirmation => "a")
    visit "/users"

    # click on user name link to go to user show page
    click_on "A A"

    #expect page to show description and due date of Example user
    expect(page).to have_content("A A")
    expect(page).to have_content("a@a.com")

  end


  # Users can delete a user.
  scenario 'User can delete a user' do

    @user = User.create(:first_name => "A", :last_name => "A", :email => "a@a.com", :password => "a", :password_confirmation => "a")
    visit "/users"

    #click on Edit
    click_on "Edit"

    #click on Delete
    click_on "Delete"

    #expect to see flash notice of successful deletion of user
    expect(page).to have_content("User was successfully destroyed.")

  end


end
