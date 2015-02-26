require 'rails_helper'


  describe 'User can signup/signin/signout' do

    # Users can create a user.
    scenario 'User can signup' do

      # visit root
      visit '/'

      # click on link to signup
      click_on "Sign Up"

      #filling out form for user
      fill_in 'user[first_name]', :with => "A"
      fill_in 'user[last_name]', :with => "A"
      fill_in 'user[email]', :with => "a@a.com"
      fill_in 'user[password]', :with => "a"
      fill_in 'user[password_confirmation]', :with => "a"

      #submitting form to create a user
      click_on "Sign Up!"

      #expect page to show user full name in navbar
      expect(page).to have_content("A A")

    end

    # Existing users can signin.
    scenario 'Existing user can signin' do

      # create user and visit root
      @user = User.create(:first_name => "A", :last_name => "A", :email => "a@a.com", :password => "a", :password_confirmation => "a")
      visit '/'

      # click on link to signin
      click_on "Sign In"

      #filling out form for signin
      fill_in 'Email', :with => "a@a.com"
      fill_in 'Password', :with => "a"

      #submitting form to signin
      click_on "Sign In!"

      #expect page to show user full name in navbar
      expect(page).to have_content("A A")

    end

    # Logged in users can signout.
    scenario 'Logged in users can signout' do

      # create user and visit root
      @user = User.create(:first_name => "A", :last_name => "A", :email => "a@a.com", :password => "a", :password_confirmation => "a")
      visit '/'

      # click on link to signin
      click_on "Sign In"

      #filling out form for signin
      fill_in 'Email', :with => "a@a.com"
      fill_in 'Password', :with => "a"

      #submitting form signin
      click_on "Sign In!"

      #expect page to show user full name in navbar
      expect(page).to have_content("A A")

      #signout
      click_on "Sign Out"

      #expect page to show sign up and sign in buttons in navbar
      expect(page).to have_content("Sign Up")
      expect(page).to have_content("Sign In")

    end

  end
