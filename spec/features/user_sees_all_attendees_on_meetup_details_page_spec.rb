require 'spec_helper'
require 'shoulda'

# As a user
# I want to see who has already joined a meetup
# So that I can see if any of my friends have joined
# Acceptance Criteria:
#
# On a meetup's show page, I should see a list of the members that have joined the meetup.
# I should see each member's avatar and username.

feature 'user sees all meetup attendees' do

    let(:user) { User.create!(
       provider: "github",
       uid: "1",
       username: "jarlax1",
       email: "jarlax1@launchacademy.com",
       avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )}

    let(:user2) { User.create!(
        provider: "github",
        uid: "2",
        username: "iseitz",
        email: "irenika@gmail.com",
        avatar_url: "https://avatars2.githubusercontent.com/u/30242649?s=460&v=4"
    )}

    before :each do

      language_discussions = Meetup.create!(
        title: "Learn new language",
        theme: "Languages",
        date: 11.days.from_now.change(hour: 13),
        begin_time: 11.days.from_now.change(hour: 13),
        end_time: 11.days.from_now.change(hour: 15),
        location:"Angel-in-us",
        description: "We will meet and create an incredible peace of art with the well known Kazakh painter Amina Abayeva ",
        user_id: user.id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      )
   end


  scenario 'Logged in user goes on the index page, clicks on the meetup link and gets to the meetup details page with a list of attendees' do

         visit '/meetups'
         # save_and_open_page
         sign_in_as user2
         visit '/meetups'
         click_link ("Learn new language")
         click_button ('Join this meetup')
         click_link "Sign Out"
         sign_in_as user
         visit '/meetups'
         click_link ("Learn new language")

         expect(page).to have_content "Members of the meetup:"
         expect(page).to have_content "Learn new language"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by: jarlax1"
         expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/30242649?s=460&v=4']")
         expect(page).to have_content "iseitz"
  end
  scenario 'Not logged in user goes on the index page, clicks on the meetup link and gets to the meetup details page with a list of attendees' do

         visit '/meetups'
         # save_and_open_page
         sign_in_as user2
         visit '/meetups'
         click_link ("Learn new language")
         click_button ('Join this meetup')
         click_link "Sign Out"

         visit '/meetups'
         click_link ("Learn new language")

         expect(page).to have_content "Members of the meetup:"
         expect(page).to have_content "Learn new language"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by: jarlax1"
         expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/30242649?s=460&v=4']")
         expect(page).to have_content "iseitz"
  end
end
