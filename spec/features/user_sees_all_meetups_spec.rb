require 'spec_helper'

 # As a user
# I want to view a list of all available meetups
# So that I can get together with people with similar interests

# Acceptance Criteria:
# On the meetups index page, I should see the name of each meetup.
# Meetups should be listed alphabetically.

 feature 'user goes on the main page and views all meetups' do

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

      scenario 'On the main page not logged in user views all the meetups in alphabetical order' do

          visit '/meetups'

          expect(page).to have_content "Meetups"
          expect(page).to have_content "Learn to crochet and get creative"
          expect(page).to have_content "Programming - girls in tech"
          expect(page).to have_content "Lets meet and let kids play"
          # You can test this with 'orderly' gem which will allow you to use appear_before or you can just do this:
          # page.body.index(new_comment_text).should < page.body.index(old_comment.text), where old and new comment are objects created with let!(:new_comment){Factory(:comment)}
          page.body.index("Get fit and healthy!").should < page.body.index("Programming - girls in tech")
          page.body.index("Learn to crochet and get creative").should < page.body.index("Lets meet and let kids play")
          # expect(page).to have_tag('ul:first-child', :text => "Get fit and healthy!")
          # expect(page).to have_selector('ul:last-child', :text => "Programming - girls in tech")
      end


      scenario 'On the main page logged in user views all the meetups in alphabetical order' do

          visit '/meetups'
          sign_in_as user

          expect(page).to have_content "You're now signed in as #{user.username}!"
          expect(page).to have_content "Meetups"
          expect(page).to have_content "Learn to crochet and get creative"
          # save_and_open_page
          expect(page).to have_content "Programming - girls in tech"
          expect(page).to have_content "Lets meet and let kids play"
          # You can test this with 'orderly' gem which will allow you to use appear_before or you can just do this:
          # page.body.index(new_comment_text).should < page.body.index(old_comment.text), where old and new comment are objects created with let!(:new_comment){Factory(:comment)}
          page.body.index("Get fit and healthy!").should < page.body.index("Programming - girls in tech")
          page.body.index("Learn to crochet and get creative").should < page.body.index("Lets meet and let kids play")
          # expect(page).to have_tag('ul:first-child', :text => "Get fit and healthy!")
          # expect(page).to have_selector('ul:last-child', :text => "Programming - girls in tech")
      end



end
