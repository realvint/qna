require 'rails_helper'

feature 'Authenticated user can answer a question', "
  In order to help to find a correct answer
  As an authenticated user
  I'd like to be able to answer the question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'My new answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'My new answer'
    end

    scenario 'answers a a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer a question' do
      visit question_path(question)
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
