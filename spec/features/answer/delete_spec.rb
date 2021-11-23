require 'rails_helper'

feature 'Author can delete his answer', "
  In order to give correct information
  As an authenticated user and author of an answer
  I'd like to be able to delete my answer
" do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:answer) { create(:answer, author: user) }

  describe 'An author of the answer' do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'deletes it' do
      expect(page).to have_content 'My answer'
      click_on 'Delete answer'
      expect(page).to have_content 'Your answer was deleted.'
      expect(page).to_not have_content 'My answer'
    end
  end

  describe 'Not an author of the answer' do
    background do
      sign_in(other_user)
      visit question_path(answer.question)
    end

    scenario 'cannot delete an answer' do
      expect(page).to have_content 'My answer'
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user cannot delete answers' do
    visit question_path(answer.question)
    expect(page).to have_content 'My answer'
    expect(page).to_not have_link 'Delete answer'
  end
end

