require 'spec_helper'
require 'shoulda'

# As a user
# I want to join a meetup
# So that I can partake in thid meetup
# Acceptance Criteria:
#
# On a meetup's show page, there should  be a button to join the meetup if
 # I am not signed in or if I am signed in but I am not a member of the meetup

# If I am signed in and I click the button I should see a message that says that
# I have joined the meetup and I should be added to the meetup's members list
# If I am not signed in and I click the button I should see a message which says
# that I must sign in

feature 'user joins the meetup' do

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

      moms_to_be = Meetup.create!(
        title: "Meet other moms to be",
        theme: "Family",
        date: 10.days.from_now.change(hour: 13),
        begin_time: 10.days.from_now.change(hour: 13),
        end_time: 10.days.from_now.change(hour: 15),
        location:"Angel-in-us",
        description: "If you are a mom to be meet other moms and chat about the new stage in your life. Clothes and toys exchange as well.",
        user_id: user.id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      )
   end


  scenario 'Logged in user goes on the index page, clicks on the meetup link and gets to the meetup details page. The user is not a member of a meetup and clicks the join button.' do

         visit '/meetups'
         # save_and_open_page
         sign_in_as user2
         visit '/meetups'
         click_link ("Meet other moms to be")
         click_button ('Join this meetup')

         expect(page).to have_content "You have sucessfully joined the meetup!"
         expect(page).to have_content "Members of the meetup:"
         expect(page).to have_content "Meet other moms to be"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by: jarlax1"
         expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/30242649?s=460&v=4']")
         expect(page).to have_content "iseitz"
         expect(page).to_not have_button 'Join this meetup'
  end
  scenario 'Not logged in user goes on the index page, clicks on the meetup link and gets to the meetup details page. The user is not an owner nor a member of a meetup and clicks the join button.' do

         visit '/meetups'

         click_link ("Meet other moms to be")
         click_button ('Join this meetup')



         expect(page).to have_content "Members of the meetup:"
         expect(page).to have_content "Meet other moms to be"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by: jarlax1"
         # save_and_open_page
         expect(page).to have_content "You must sign in first!"
  end
  scenario 'Logged in user, owner of the meetup goes on the index page, clicks on their meetup link and gets to the meetup details page. The user does not see the join button.' do

    visit '/meetups'
    # save_and_open_page
    sign_in_as user
    visit '/meetups'
    click_link ("Meet other moms to be")

    expect(page).to_not have_button 'Join this meetup'
    expect(page).to have_content "Members of the meetup:"
    expect(page).to have_content "Meet other moms to be"
    expect(page).to have_content "Description:"
    expect(page).to have_content "Organized by: jarlax1"
  end
  scenario 'Logged in user, member of the meetup goes on the index page, clicks on the link of a meetup they already joined and gets to the meetup details page. The user does not see the join button.' do

    visit '/meetups'
    # save_and_open_page
    sign_in_as user2
    visit '/meetups'
    click_link ("Meet other moms to be")
    click_button ("Join this meetup")
    click_link ("Back to all meetups")
    click_link ("Meet other moms to be")

    expect(page).to_not have_button 'Join this meetup'
    expect(page).to have_content "Members of the meetup:"
    expect(page).to have_content "Meet other moms to be"
    expect(page).to have_content "Description:"
    expect(page).to have_content "Organized by: jarlax1"
    expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/30242649?s=460&v=4']")
    expect(page).to have_content "iseitz"
  end
end
