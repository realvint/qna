require 'rails_helper'

feature 'Only author can delete his question', "
  In order to express one's opinion
  As an authenticated user and author of question
  I'd like to be to delete my question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_user) { create(:user) }

  describe 'An author of the question' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'deletes it', js: true do
      click_on 'Delete'

      accept_alert 'Are you sure?'

      expect(page).to have_content 'Your question was deleted.'
    end
  end

  describe 'Not an author of the question' do
    background do
      sign_in(other_user)
      visit questions_path
    end

    scenario 'cannot delete a question' do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user cannot delete question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
