require 'spec_helper'

# As a user
# I want to view the details of a meetup
# So that I can learn more about its purpose
#
# Acceptance Criteria:
# On index page, the name of each meetup should be a link to the meetups show page
# On the show page, I should see the name, description, location, and the creator of the meetup


feature 'user goes on the show meetup details page and views all details' do

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

    sports_meetup = Meetup.create!(
      title: "Get fit and healthy!",
      theme: "Sports",
      date: "February 20th, 2019",
      begin_time: DateTime.now + 1.week,
      end_time: DateTime.now + 1.week,
      location:"Colibri center",
      description: " We will meet and workout together! Jog or stroll jump or walk but move",
      user_id: user2.id,
      created_at: DateTime.now,
      updated_at: DateTime.now
    )

   crocheting_meetup = Meetup.create!(
        title: "Learn to crochet and get creative",
        theme: "Handmade",
        date: DateTime.now + 6.day,
        begin_time: '2019-02-06 15:00:00 UTC'.to_time,
        end_time: '2019-02-06 17:00:00 UTC'.to_time,
        location:"Dostyk plaza",
        description: " We will teach you to crochet and create nice stuff",
        user_id: user.id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      )

     programming_meetup = Meetup.create!(
        title: "Programming - girls in tech",
        theme: "Tech/IT",
        date: 7.days.from_now.change(hour: 10),
        begin_time: 7.days.from_now.change(hour: 10),
        end_time: 7.days.from_now.change(hour: 13),
        location:"Dostyk plaza",
        description: "Let's network and share our programming knowledge and experience",
        user_id: user2.id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      )

      family_meetup = Meetup.create!(
        title: "Lets meet and let kids play",
        theme: "Family",
        date: '2019-02-06 15:00:00 UTC'.to_date,
        begin_time: '2019-02-06 15:00:00 UTC'.to_time,
        end_time: '2019-02-06 17:00:00 UTC'.to_time,
        location:"48 Panfilovcev Park",
        description: "Big playdate for parents and kids",
        user_id: user.id,
        created_at: DateTime.now,
        updated_at: DateTime.now
      )
  end

  scenario 'Looged in user goes on the index page, clicks on the show meetup\'s details page link and views details of the meetup' do

         visit '/meetups'
         sign_in_as user
         visit '/meetups'
         # save_and_open_page
         click_link ('Programming - girls in tech')

         expect(page).to have_content 'Programming - girls in tech'
         expect(page).to have_content "Let's network and share our programming knowledge and experience"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by:"
         expect(page).to have_content "iseitz"

  end

  scenario 'Not looged in user goes on the index page, clicks on the show meetup\'s details page link and views details of the meetup' do

         visit '/meetups'
         # save_and_open_page
         click_link ('Programming - girls in tech')

         expect(page).to have_content 'Programming - girls in tech'
         expect(page).to have_content "Let's network and share our programming knowledge and experience"
         expect(page).to have_content "Description:"
         expect(page).to have_content "Organized by:"
         expect(page).to have_content "iseitz"

  end
end
