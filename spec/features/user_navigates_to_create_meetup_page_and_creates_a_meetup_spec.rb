require 'spec_helper'
require 'shoulda'

# As a user
# I want to create a meetup
# So that I can gather a group of people to do an activity

# Acceptance Criteria:
# There should be a link from the index page that takes you to the meetups  new page. On this page there is a form to create a new meetup
# I must be signed in and must supply a name, location, description of the meetup
# If the form submission is sucessfull I should be brought to the meetup's show page, and I should see a message that lets me know that I have
# created meetup sucessfully
# If the form submission is unsucsessful I should remain in the meetups new page, and I should see error messages explaining
# why the form submission was unsucsessful. The form should be pre-filled with the values that were provided when the form
# was submitted.

feature 'user creates a meetup' do

  let(:user) { User.create!(
       provider: "github",
       uid: "1",
       username: "jarlax1",
       email: "jarlax1@launchacademy.com",
       avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
     )}

  before :each do

    user2 = User.create!(
        provider: "github",
        uid: "2",
        username: "iseitz",
        email: "irenika@gmail.com",
        avatar_url: "https://avatars2.githubusercontent.com/u/30242649?s=460&v=4"
      )

    painting_meetup = Meetup.create!(
      title: "Creating your own painting with friends",
      theme: "Art",
      date: 9.days.from_now.change(hour: 10),
      begin_time: 9.days.from_now.change(hour: 10),
      end_time: 9.days.from_now.change(hour: 13),
      location:"Dostyk Plaza Art Space",
      description: " We will meet and create an incredible peace of art with the well known Kazakh painter Amina Abayeva ",
      user_id: user.id,
      created_at: DateTime.now,
      updated_at: DateTime.now
    )


    hackathon_meetup = Meetup.create!(
      title: "Hack it fast!",
      theme: "Tech/IT",
      date: '2019-02-10 12:00:00 UTC'.to_date,
      begin_time: '2019-02-10 12:00:00 UTC'.to_time,
      end_time: '2019-02-10 22:00:00 UTC'.to_time,
      location:"Computer Club on Snegina",
      description: "There will be a banch of tasks to hack and a lot of fun",
      user_id: user.id,
      created_at: DateTime.now,
      updated_at: DateTime.now
      )
  end

  scenario 'Not logged in user goes on the index page, clicks on the create meetup link and gets to the new page with a form' do

         visit '/meetups'
         # save_and_open_page
         click_link ('Create your meetup')

         expect(page).to have_content 'Theme'
         expect(page).to have_content "Add Your Meetup Here"
         expect(page).to have_content "Description:"
         expect(page).to have_button "Create Meetup"
  end

  scenario 'Looged in user goes on the index page, clicks on the create meetup link and gets to the new page with a form' do

         visit '/meetups'
         sign_in_as user
         visit '/meetups'
         # save_and_open_page
         click_link ('Create your meetup')

         expect(page).to have_content 'Theme'
         expect(page).to have_content "Add Your Meetup Here"
         expect(page).to have_content "Description:"
         expect(page).to have_button "Create Meetup"
  end
  scenario 'Not logged in user fills in the form, clicks on submit button and gets a notofocation that he needs to sign in' do

         visit '/meetups'

         click_link ('Create your meetup')
         fill_in('Title:', :with => 'French Language Lunch and Discussions')
         select('Languages', :from => 'Theme')
         fill_in('Date:', :with => '02/10/2019')
         fill_in('Begins at:', :with => '01:00PM')
         fill_in('Ends at:', :with => '02:00PM')
         fill_in('Location:', :with => 'French Cafe')
         fill_in('Description:', :with => 'For practice and learning lets meet eat together and chat in French')

         click_button('Create Meetup')
         click_button('Create Meetup')

         expect(page).to have_content "Add Your Meetup Here"
         expect(page).to have_button "Create Meetup"
         expect(page).to have_content 'Theme'
         expect(page).to have_content "Description:"
         expect(page).to have_content "You must sign in first!"

  end
  scenario 'Logged out user does not fill in the form, clicks on submit button and gets a notofocation that he needs to sign in' do

         visit '/meetups'
         click_link ('Create your meetup')

         click_button('Create Meetup')
         click_button('Create Meetup')

         expect(page).to have_content "Add Your Meetup Here"
         expect(page).to have_button "Create Meetup"
         expect(page).to have_content 'Theme'
         expect(page).to have_content "Description:"
         expect(page).to have_content "You must sign in first!"

  end
  scenario 'Logged in user does not fill all the form, clicks on submit button and gets error messages that he needs to fill in missing fields' do

         visit '/meetups'
         sign_in_as user
         visit '/meetups'

         click_link ('Create your meetup')
         select('Languages', :from => 'Theme')
         fill_in('Date:', :with => '02/10/2019')
         fill_in('Begins at:', :with => '01:00PM')
         fill_in('Ends at:', :with => '02:00PM')
         fill_in('Description:', :with => 'For practice and learning lets meet eat together and chat in French')

         click_button('Create Meetup')

         expect(page).to have_content "Add Your Meetup Here"
         expect(page).to have_button "Create Meetup"
         expect(page).to have_content 'Theme'
         expect(page).to have_content "Description:"
         expect(page).to have_content "Title can't be blank Location can't be blank"
  end
  scenario 'Logged in user fill in all the form, submitS it, gets redirected to the index page and sees success message in index page' do

         visit '/meetups'
         sign_in_as user
         visit '/meetups'

         click_link ('Create your meetup')
         fill_in('Title:', :with => 'French Language Lunch and Discussions')
         select('Languages', :from => 'Theme')
         fill_in('Date:', :with => '02/10/2019')
         fill_in('Begins at:', :with => '01:00PM')
         fill_in('Ends at:', :with => '02:00PM')
         fill_in('Location:', :with => 'French Cafe')
         fill_in('Description:', :with => 'For practice and learning lets meet eat together and chat in French')
         click_button('Create Meetup')

         expect(page).to have_content "Meetups"
         expect(page).to have_content "Creating your own painting with friends"
         expect(page).to have_content "Hack it fast!"
         expect(page).to have_content "Create your meetup"
         expect(page).to have_content "You have sucessfully created a meetup!"
  end
end
